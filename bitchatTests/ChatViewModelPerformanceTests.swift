//
// ChatViewModelPerformanceTests.swift
// bitchatTests
//

import XCTest
import BitFoundation
@testable import bitchat

final class ChatViewModelPerformanceTests: XCTestCase {

    // Create a large number of dummy chats and messages to test migration performance
    @MainActor
    func testMigratePrivateChatsPerformance() throws {
        // Create dependencies
        let keychain = MockKeychain()
        let keychainHelper = MockKeychainHelper()
        let idBridge = NostrIdentityBridge(keychain: keychainHelper)
        let identityManager = MockIdentityManager(keychain)
        let transport = MockTransport()

        let viewModel = ChatViewModel(
            keychain: keychain,
            idBridge: idBridge,
            identityManager: identityManager,
            transport: transport
        )

        let targetPeerID = PeerID(uuidString: "00000000-0000-0000-0000-000000000000")!
        let targetNickname = "TargetUser"
        viewModel.nickname = "CurrentUser"

        // Setup 10,000 dummy chats
        for i in 0..<10000 {
            let oldPeerID = PeerID(uuidString: String(format: "%08X-0000-0000-0000-000000000000", i))!

            var messages: [BitchatMessage] = []

            // Generate 100 messages for each chat
            let baseTime = Date()
            for j in 0..<100 {
                let msgTime = baseTime.addingTimeInterval(TimeInterval(-j * 3600)) // 1 hour apart
                let msg = BitchatMessage(
                    id: UUID().uuidString,
                    sender: "OtherUser\(i)",
                    senderPeerID: oldPeerID.uuidString,
                    recipientNickname: "CurrentUser",
                    content: "Message \(j)",
                    timestamp: msgTime,
                    isPrivate: true,
                    encryptionType: .plaintext
                )
                messages.append(msg)
            }

            viewModel.privateChats[oldPeerID] = messages

            // Set fingerprints for only a few to make fallback path the main path
            if i % 100 == 0 {
                viewModel.peerIDToPublicKeyFingerprint[oldPeerID] = "fingerprint\(i)"
            }
        }

        // Measure performance
        measure {
            viewModel.migratePrivateChatsIfNeeded(for: targetPeerID, senderNickname: targetNickname)
        }
    }
}
