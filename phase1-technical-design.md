# Phase 1 Technical Design Doc: bitchat Online Magic MVP

This document outlines the technical implementation plan for transitioning `bitchat` into an online-first, decentralized super-app.

## 1. Seed-Based Identity (BIP39) via Keychain Manager

### 1.1 Goal
Migrate from generating ephemeral Nostr identities dynamically to a deterministic identity backed by a BIP39 seed phrase, while maintaining the security of the current Keychain implementation.

### 1.2 Implementation Steps
1. **Dependency Addition:** Integrate a Swift-native BIP39 library (e.g., `swift-bip39`) via Swift Package Manager to handle mnemonic generation and seed derivation.
2. **`KeychainManager.swift` Update:**
   - Add methods to store and retrieve the BIP39 mnemonic securely using the existing app group `group.chat.bitchat` keychain service.
   - Example: `func saveMnemonic(_ mnemonic: String) -> Bool` and `func getMnemonic() -> String?`.
3. **`NostrIdentityBridge.swift` Update:**
   - Update identity derivation. Instead of random generation, derive the Nostr private key (BIP340) deterministically from the BIP39 seed (using BIP32/BIP44 paths, commonly `m/44'/1237'/0'/0/0` for Nostr).
4. **UX Flow:** Introduce a "Backup Phrase" screen in the UI to allow users to write down their seed phrase and a "Restore Account" flow during onboarding.

## 2. Cross-Device Sync over Nostr (NIP-17)

### 2.1 Goal
Enable seamless history syncing between devices (e.g., iPhone and Mac) without relying on a central server, utilizing Nostr relays.

### 2.2 Implementation Steps
1. **Self-DM Strategy:** Since all devices sharing the same seed phrase derive the same Nostr identity, cross-device sync can be achieved by sending messages *to oneself*.
2. **NIP-17 Gift Wrapping:**
   - Update `Services/MessageRouter.swift` and `Services/NostrTransport.swift`.
   - When a private message is sent, simultaneously broadcast a NIP-17 gift-wrapped version addressed to the sender's own public key.
3. **Sync Ingestion:**
   - Modify `ChatViewModel`'s subscription logic to actively listen for incoming NIP-17 events addressed to the user.
   - When a self-addressed message is received, parse it and inject it into the local `PrivateChatManager`, deduplicating using the existing `MessageDeduplicator` to prevent looping.

## 3. Global Ephemeral Channels (Kind 20002)

### 3.1 Goal
Support temporary, topic-based public channels that span the global Nostr network, distinct from the current localized geohash implementation.

### 3.2 Implementation Steps
1. **Protocol Definition:** Define a new Custom Nostr Event Kind (e.g., `20002` for Ephemeral Topic Chat) in `bitchat/Nostr/NostrProtocol.swift`.
2. **Tags and Metadata:**
   - Ensure these events include an expiration tag (`expiration`) to enforce the 24h TTL natively on supporting relays (NIP-40).
   - Use a specific topic tag (e.g., `t` tag for `#superbowl-live`).
3. **Relay Strategy:** Update `NostrRelayManager.swift` to route topic-based channel subscriptions to specific high-traffic or topic-dedicated relays, utilizing relay hints in the event tags.
4. **UI Integration:** Add a "Discover Channels" view in SwiftUI allowing users to search by topic (hashtag) and join the ephemeral stream.

## 4. Lightning Network Payments via LDK

### 4.1 Goal
Integrate instant micropayments directly into the chat interface for tipping, paywalls, and mesh incentivization.

### 4.2 Implementation Steps
1. **Dependency Addition:** Integrate the Lightning Development Kit (LDK) Swift bindings via Swift Package Manager (`swift-ldk`).
2. **Node Initialization:**
   - Create an `LDKManager.swift` service to initialize a self-custodial Lightning node on the mobile device.
   - The node's seed should be derived securely from the main BIP39 mnemonic established in step 1.
3. **Wallet Sync:** Implement a lightweight block sync mechanism (e.g., Rapid Gossip Sync or Electrum servers) so the mobile node can efficiently find routes without downloading the full blockchain.
4. **In-Chat UX:**
   - Extend `MessageFormattingEngine.swift` to recognize Lightning invoices (Bolt11).
   - Add a "Pay" button to recognized invoices in the timeline.
   - Implement "Zaps" (NIP-57) to allow sending tips directly to a user's pubkey by querying their Lightning Address embedded in their Nostr profile metadata.