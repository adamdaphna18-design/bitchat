//
// PrivateChatManager.swift
// bitchat
//
// Manages private chat sessions and messages
// This is free and unencumbered software released into the public domain.
//

import BitLogger
import BitFoundation
import Foundation
import SwiftUI

/// Manages all private chat functionality
final class PrivateChatManager: ObservableObject {
    @Published var privateChats: [PeerID: [BitchatMessage]] = [:]
    @Published var selectedPeer: PeerID? = nil
    @Published var unreadMessages: Set<PeerID> = []

    private var selectedPeerFingerprint: String? = nil
    var sentReadReceipts: Set<String> = []  // Made accessible for ChatViewModel
    private var seenMessageIDs: Set<String> = []
    private var messageRegistry: [String: BitchatMessage] = [:]

    weak var meshService: Transport?
    // Route acks/receipts via MessageRouter (chooses mesh or Nostr)
    weak var messageRouter: MessageRouter?
    // Peer service for looking up peer info during consolidation
    weak var unifiedPeerService: UnifiedPeerService?

    init(meshService: Transport? = nil) {
        self.meshService = meshService
        loadSeenMessageIDs()
    }

    // Cap for messages stored per private chat
    private let privateChatCap = TransportConfig.privateChatCap

    // MARK: - Message Consolidation

    /// Consolidates messages from different peer ID representations into a single chat.
    /// This ensures messages from stable Noise keys and temporary Nostr peer IDs are merged.
    /// - Parameters:
    ///   - peerID: The target peer ID to consolidate messages into
    ///   - peerNickname: The peer's display name (lowercased for matching)
    ///   - persistedReadReceipts: The persisted read receipts set from ChatViewModel (UserDefaults-backed)
    /// - Returns: True if any unread messages were found during consolidation
    @MainActor
    func consolidateMessages(for peerID: PeerID, peerNickname: String, persistedReadReceipts: Set<String>) -> Bool {
        guard let meshService = meshService else { return false }
        var hasUnreadMessages = false

        // 1. Consolidate from stable Noise key (64-char hex)
        if let peer = unifiedPeerService?.getPeer(by: peerID) {
            let noiseKeyHex = PeerID(hexData: peer.noisePublicKey)

            if noiseKeyHex != peerID, let nostrMessages = privateChats[noiseKeyHex], !nostrMessages.isEmpty {
                if privateChats[peerID] == nil {
                    privateChats[peerID] = []
                }

                let existingMessageIds = Set(privateChats[peerID]?.map { $0.id } ?? [])
                for message in nostrMessages {
                    recordMessageID(message.id, message: message)
                    if !existingMessageIds.contains(message.id) {
                        // Update senderPeerID for correct read receipts
                        let updatedMessage = BitchatMessage(
                            id: message.id,
                            sender: message.sender,
                            content: message.content,
                            timestamp: message.timestamp,
                            isRelay: message.isRelay,
                            originalSender: message.originalSender,
                            isPrivate: message.isPrivate,
                            recipientNickname: message.recipientNickname,
                            senderPeerID: message.senderPeerID == meshService.myPeerID ? meshService.myPeerID : peerID,
                            mentions: message.mentions,
                            deliveryStatus: message.deliveryStatus
                        )
                        privateChats[peerID]?.append(updatedMessage)

                        // Check for recent unread messages (< 60s, not sent by us, not already read)
                        // Use persistedReadReceipts to correctly identify already-read messages after app restart
                        if message.senderPeerID != meshService.myPeerID {
                            let messageAge = Date().timeIntervalSince(message.timestamp)
                            if messageAge < 60 && !persistedReadReceipts.contains(message.id) {
                                hasUnreadMessages = true
                            }
                        }
                    }
                }

                sanitizeChat(for: peerID)

                if hasUnreadMessages {
                    unreadMessages.insert(peerID)
                } else if unreadMessages.contains(noiseKeyHex) {
                    unreadMessages.remove(noiseKeyHex)
                }

                privateChats.removeValue(forKey: noiseKeyHex)
            }
        }

        // 2. Consolidate from temporary Nostr peer IDs (nostr_* prefixed)
        let normalizedNickname = peerNickname.lowercased()
        var tempPeerIDsToConsolidate: [PeerID] = []

        for (storedPeerID, messages) in privateChats {
            if storedPeerID.isGeoDM && storedPeerID != peerID {
                let nicknamesMatch = messages.allSatisfy { $0.sender.lowercased() == normalizedNickname }
                if nicknamesMatch && !messages.isEmpty {
                    tempPeerIDsToConsolidate.append(storedPeerID)
                }
            }
        }

        if !tempPeerIDsToConsolidate.isEmpty {
            if privateChats[peerID] == nil {
                privateChats[peerID] = []
            }

            let existingMessageIds = Set(privateChats[peerID]?.map { $0.id } ?? [])
            var consolidatedCount = 0
            var hadUnreadTemp = false

            for tempPeerID in tempPeerIDsToConsolidate {
                if unreadMessages.contains(tempPeerID) {
                    hadUnreadTemp = true
                }

                if let tempMessages = privateChats[tempPeerID] {
                    for message in tempMessages {
                        recordMessageID(message.id, message: message)
                        if !existingMessageIds.contains(message.id) {
                            let updatedMessage = BitchatMessage(
                                id: message.id,
                                sender: message.sender,
                                content: message.content,
                                timestamp: message.timestamp,
                                isRelay: message.isRelay,
                                originalSender: message.originalSender,
                                isPrivate: message.isPrivate,
                                recipientNickname: message.recipientNickname,
                                senderPeerID: peerID,
                                mentions: message.mentions,
                                deliveryStatus: message.deliveryStatus
                            )
                            privateChats[peerID]?.append(updatedMessage)
                            consolidatedCount += 1
                        }
                    }
                    privateChats.removeValue(forKey: tempPeerID)
                    unreadMessages.remove(tempPeerID)
                }
            }

            if hadUnreadTemp {
                unreadMessages.insert(peerID)
                hasUnreadMessages = true
                SecureLogger.debug("📬 Transferred unread status from temp peer IDs to \(peerID)", category: .session)
            }

            if consolidatedCount > 0 {
                sanitizeChat(for: peerID)
                SecureLogger.info("📥 Consolidated \(consolidatedCount) Nostr messages from temporary peer IDs to \(peerNickname)", category: .session)
            }
        }

        return hasUnreadMessages
    }

    /// Syncs the read receipt tracking between manager and view model for sent messages
    @MainActor
    func syncReadReceiptsForSentMessages(peerID: PeerID, nickname: String, externalReceipts: inout Set<String>) {
        guard let messages = privateChats[peerID] else { return }

        for message in messages {
            if message.sender == nickname {
                if let status = message.deliveryStatus {
                    switch status {
                    case .read, .delivered:
                        externalReceipts.insert(message.id)
                        sentReadReceipts.insert(message.id)
                    case .failed, .partiallyDelivered, .sending, .sent:
                        break
                    }
                }
            }
        }
    }
    
    /// Start a private chat with a peer
    func startChat(with peerID: PeerID) {
        selectedPeer = peerID
        
        // Store fingerprint for persistence across reconnections
        if let fingerprint = meshService?.getFingerprint(for: peerID) {
            selectedPeerFingerprint = fingerprint
        }
        
        // Mark messages as read
        markAsRead(from: peerID)
        
        // Initialize chat if needed
        if privateChats[peerID] == nil {
            privateChats[peerID] = []
        }
    }
    
    /// End the current private chat
    func endChat() {
        selectedPeer = nil
        selectedPeerFingerprint = nil
    }

    /// Remove duplicate messages by ID and keep chronological order, while enforcing the storage cap.
    func sanitizeChat(for peerID: PeerID) {
        guard let arr = privateChats[peerID] else { return }

        // 1. De-duplicate and Sort
        var deduped: [BitchatMessage] = []
        if arr.count > 1 {
            var indexByID: [String: Int] = [:]
            indexByID.reserveCapacity(arr.count)
            deduped.reserveCapacity(arr.count)

            for msg in arr.sorted(by: { $0.timestamp < $1.timestamp }) {
                if let existing = indexByID[msg.id] {
                    deduped[existing] = msg
                } else {
                    indexByID[msg.id] = deduped.count
                    deduped.append(msg)
                }
            }
        } else {
            deduped = arr
        }

        // 2. Enforce Cap
        if deduped.count > privateChatCap {
            let dropped = Array(deduped.prefix(deduped.count - privateChatCap))
            for msg in dropped {
                messageRegistry.removeValue(forKey: msg.id)
            }
            deduped = Array(deduped.suffix(privateChatCap))
        }

        privateChats[peerID] = deduped
    }
    
    /// Mark messages from a peer as read
    func markAsRead(from peerID: PeerID) {
        unreadMessages.remove(peerID)
        
        // Send read receipts for unread messages that haven't been sent yet
        if let messages = privateChats[peerID] {
            for message in messages {
                recordMessageID(message.id, message: message)
                if message.senderPeerID == peerID && !message.isRelay && !sentReadReceipts.contains(message.id) {
                    sendReadReceipt(for: message)
                }
            }
        }
    }

    // MARK: - Deduplication

    /// Check if message is duplicate.
    /// - Parameter messageID: The message identifier to check.
    /// - Returns: `true` if the message was already seen, `false` otherwise.
    func isDuplicate(_ messageID: String) -> Bool {
        return seenMessageIDs.contains(messageID)
    }

    /// Record a message in the global registry and seen set.
    /// - Parameters:
    ///   - messageID: The message identifier to record.
    ///   - message: Optional message instance for O(1) status updates.
    func recordMessageID(_ messageID: String, message: BitchatMessage? = nil) {
        seenMessageIDs.insert(messageID)
        if let message = message {
            messageRegistry[messageID] = message
        }

        // Bounding the registry and seen set to prevent memory leaks
        // seenMessageIDs is kept larger to prevent duplicate notifications for older messages
        if messageRegistry.count > 5000 {
            let keysToRemove = Array(messageRegistry.keys.prefix(1000))
            for key in keysToRemove {
                messageRegistry.removeValue(forKey: key)
            }
        }

        if seenMessageIDs.count > 10000 {
            let idsToRemove = Array(seenMessageIDs.prefix(2000))
            for id in idsToRemove {
                seenMessageIDs.remove(id)
            }
        }
    }

    /// Retrieve a message instance by its ID.
    /// - Parameter messageID: The message identifier.
    /// - Returns: The message instance if found in the registry.
    func message(withID messageID: String) -> BitchatMessage? {
        return messageRegistry[messageID]
    }

    /// Remove a specific message ID from the registry and seen set.
    /// - Parameter messageID: The message identifier to remove.
    func removeMessageID(_ messageID: String) {
        seenMessageIDs.remove(messageID)
        messageRegistry.removeValue(forKey: messageID)
    }

    /// Clear all seen message IDs and the registry.
    func clearAllMessageIDs() {
        seenMessageIDs.removeAll()
        messageRegistry.removeAll()
    }

    // MARK: - Persistence

    /// Persists seen message IDs to disk.
    /// Should be called during app backgrounding or termination to avoid excessive IO.
    func saveState() {
        // Limit the number of IDs persisted to prevent performance degradation with UserDefaults
        let limit = 5000
        let idsToPersist = seenMessageIDs.count > limit
            ? Array(seenMessageIDs.prefix(limit))
            : Array(seenMessageIDs)

        if let data = try? JSONEncoder().encode(idsToPersist) {
            UserDefaults.standard.set(data, forKey: "bitchat.seenMessageIDs")
        }
    }

    private func loadSeenMessageIDs() {
        if let data = UserDefaults.standard.data(forKey: "bitchat.seenMessageIDs"),
           let ids = try? JSONDecoder().decode([String].self, from: data) {
            seenMessageIDs = Set(ids)
        }
    }
    
    // MARK: - Private Methods
    
    private func sendReadReceipt(for message: BitchatMessage) {
        guard !sentReadReceipts.contains(message.id),
              let senderPeerID = message.senderPeerID else {
            return
        }
        
        sentReadReceipts.insert(message.id)
        
        // Create read receipt using the simplified method
        let receipt = ReadReceipt(
            originalMessageID: message.id,
            readerID: meshService?.myPeerID ?? PeerID(str: ""),
            readerNickname: meshService?.myNickname ?? ""
        )
        
        // Route via MessageRouter to avoid handshakeRequired spam when session isn't established
        if let router = messageRouter {
            SecureLogger.debug("PrivateChatManager: sending READ ack for \(message.id.prefix(8))… to \(senderPeerID.id.prefix(8))… via router", category: .session)
            Task { @MainActor in
                router.sendReadReceipt(receipt, to: senderPeerID)
            }
        } else {
            // Fallback: preserve previous behavior
            meshService?.sendReadReceipt(receipt, to: senderPeerID)
        }
    }
}
