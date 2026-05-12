# bitchat Reverse-Engineering Report

## 1. Architecture Overview
`bitchat` is a decentralized, peer-to-peer messaging application designed to operate using a dual-transport architecture.
It functions via:
- **Bluetooth Low Energy (BLE) Mesh Network:** For local, multi-hop, and completely offline communication. This is implemented via `CoreBluetooth` in `bitchat/Services/BLE/BLEService.swift`.
- **Nostr Protocol Transport:** A fallback for global communication via internet relays. Location-based "geohash" channels are used to group users geographically via Nostr ephemeral events (`bitchat/Services/NostrTransport.swift`, `bitchat/Services/GeohashPresenceService.swift`).

The app's UI is built entirely in **SwiftUI**. Data flow and business logic are managed primarily by `ChatViewModel.swift`, which acts as the application's central nervous system, consuming network events from `BitchatDelegate` and broadcasting updates using Combine/`ObservableObject`.

Message routing is intelligently orchestrated by `Services/MessageRouter.swift`, which determines whether to enqueue a message via Mesh or send it via Nostr based on the peer's connection status.

## 2. Key Features

### 2.1 Encryption & Privacy
- **End-to-End Encryption:** `bitchat` utilizes the **Noise Protocol Framework** (specifically the `XX` pattern with `Curve25519`, `ChaCha20-Poly1305`, and `SHA-256`) for secure authentication and forward secrecy over the BLE Mesh. The logic is cleanly encapsulated in the `bitchat/Noise/` directory (`NoiseProtocol.swift`, `NoiseSession.swift`).
- **Nostr NIP-17:** For the internet transport fallback, messages are gift-wrapped according to NIP-17 standards to obscure metadata and secure direct messages.
- **Identity Storage:** Ephemeral keys and stable Noise keys are stored securely using macOS/iOS Keychains (`KeychainManager.swift`, `SecureIdentityStateManager.swift`).

### 2.2 Message Synchronization
- **Gossip Sync:** The app employs a resilient flooding mechanism (`Sync/GossipSyncManager.swift`) that utilizes an `OptimizedBloomFilter` to prevent message loops. Time-to-Live (TTL) variables decrement at each hop to contain network storms.
- **Request Sync:** A separate `RequestSyncManager.swift` attributes Request-Sync Responses (RSR) to specific peers for handling missing message fragments or gaps.
- **Deduplication:** A `MessageDeduplicator` (`Utils/MessageDeduplicator.swift`) actively screens out redundant network broadcasts before they reach the UI timeline.

### 2.3 Message Lifecycle
- **Fragmentation:** `BLEService` handles chunking large payloads (`fragmentStart`, `fragmentContinue`, `fragmentEnd`) since BLE MTU sizes are heavily constrained (default fragment size is 469 bytes).
- **Rich Text & Mentions:** `MessageFormattingEngine.swift` powers text parsing, mentions, and URL highlights natively within SwiftUI.

## 3. Protocol Analysis

### 3.1 Device Discovery
- **Mesh Discovery:** Devices continuously broadcast and scan for the `bitchat` BLE Service UUID (`F47B5E2D...`). Connection topologies are tracked using `MeshTopologyTracker.swift`, mapping neighbor adjacencies.
- **Nostr Discovery:** Devices derive geohashes based on location precision and subscribe to Nostr channels (e.g. `block #dr5rsj7`). Users broadcast ephemeral presence heartbeats (Kind 20001) to signal their availability in a specific geographic area (`GeohashPresenceService.swift`).

### 3.2 Message Signing & Verification
- Packets are serialized into a highly optimized binary format padding out to standard blocks (256, 512 bytes, etc) to obscure message lengths from observers (`BitchatProtocol.swift`).
- Verification between users is out-of-band: `VerificationService.swift` generates deterministic QR codes encoding the user's Noise Public Key, Nickname, and an `Ed25519` signature. Once scanned by a peer, the application establishes a trusted relationship.

## 4. Security Assessment

Based on source code heuristics:
- **Cryptography Usage:** Good security hygiene. The code utilizes established primitives (Noise, CryptoKit). Sessions correctly execute thread-safe barriers (`sessionQueue.sync(flags: .barrier)`) when encrypting or mutating handshake states.
- **Denial of Service protections:** The implementation includes a `NoiseRateLimiter` to throttle rapid handshake attacks, and size validation (`NoiseSecurityValidator.swift`) to drop illegally oversized payloads immediately.
- **Memory Safety:** As it is written entirely in Swift, the codebase benefits from memory safety by default (no raw pointer manipulation was observed in standard routing).
- **Weaknesses/Trade-offs:**
  - Bloom filter gossip networks are inherently noisy and susceptible to false positives (legitimate messages might be dropped if hash collisions occur).
  - Tor connections are utilized dynamically (`BitchatApp.swift`), but any failure to route via Tor before Nostr connection initialization might temporarily leak user IP to the initial relay.

## 5. Missing Pieces / Gap Analysis

Compared to standard decentralized platforms (e.g. Signal, Briar):
1. **Multi-device Sync:** There appears to be no unified account system that synchronizes messages across multiple personal devices (e.g., matching iOS to macOS under a single profile). Identities are per-device due to the localized keychain storage and lack of central servers.
2. **Robust Group Chats (Mesh):** While geographic location channels exist via Nostr, persistent, named, and end-to-end encrypted group chats (like Signal Groups) over the offline Mesh do not seem fully fleshed out; Mesh relies mostly on public floods or 1-to-1 direct messaging.
3. **PFS (Perfect Forward Secrecy) on Nostr DMs:** While the Mesh uses the Noise protocol providing true forward secrecy via key rotation, the Nostr DM transport relies on NIP-17, which provides confidentiality but lacks the ratcheting mechanisms of Noise/Signal.
4. **Media Attachments:** The `TransportConfig.swift` shows rate limits for concurrent file transfers (`bleMaxConcurrentTransfers = 2`), but BLE throughput is inherently extremely slow for media sharing compared to Wi-Fi Direct or AirDrop.

## 6. Future Integration Plan

### 6.1 Post-Quantum Cryptography (PQC)
*   **Goal**: Future-proof the app against attacks from quantum computers.
*   **Solution**: Integrate NIST-standardized algorithms for forward secrecy.
*   **Open-Source Implementation**:
    *   **Recommended Library**: `liboqs` (C) with a Swift wrapper, or utilize Apple's built-in `CryptoKit` which now supports ML-KEM (key agreement) and ML-DSA (digital signatures).
    *   **Fallback Strategy**: Use a hybrid approach for Nostr (e.g., X25519 + ML-KEM) and a quantum-resistant PSK for WireGuard-like tunnels.

### 6.2 Lightning Network Payments
*   **Goal**: Enable instant, low-fee micropayments directly within the chat interface.
*   **Integration Points**: Use payments to reward mesh network relays, incentivize file storage, or enable paywalled content.
*   **Open-Source Implementation**:
    *   **Recommended Library**: `Lightning Development Kit (LDK)` — a flexible, Rust-based library with high-quality Swift bindings that allow for a self-custodial mobile node.
    *   **Backend Option**: The `lnd` mobile library for those preferring a full gRPC-based Lightning node.

### 6.3 Decentralized Storage & Telegram Integration
*   **Goal**: Solve file-sharing limitations and sync data without central servers.
*   **Integration Points**: Store large media attachments, sync user profiles across devices, or host public group data.
*   **Open-Source Implementation**:
    *   **Recommended Library**: `TON Storage` — a DHT-based system integrated with The Open Network (TON) blockchain for economic incentives.
    *   **The "Telegram Drive" Reference**: A Telegram Web App (`TON Drive`) uses TON Storage to bypass file size limits. For `bitchat`, you could implement a direct-to-storage upload flow, with a bot interface for management.
    *   **Alternative**: For legacy support, use the `Telegram Bot API` (via `swift-telegram-sdk`) for file hosting (up to 2GB).
