## 2024-05-24 - Avoid `.filter { ... }.count` chaining
**Learning:** Found an instance of `messages.allPackets { _ in true }.filter { PeerID(hexData: $0.senderID) == peerID }.count` which causes an intermediate array allocation just to count elements.
**Action:** Replace `.filter { ... }.count` with `.reduce(0) { $0 + (... ? 1 : 0) }` for better memory efficiency and to avoid unnecessary allocations, especially in a Swift 5.9 environment where `.count(where:)` might not be supported on all sequence types without extra extensions.
