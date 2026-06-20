## 2024-06-20 - Sequence counting performance optimization
**Learning:** In Swift, chaining `.filter { condition }.count` creates an intermediate array allocation for the filtered elements before counting them. This can be computationally expensive on hot paths like BLE connection managers or list filtering.
**Action:** Replace `.filter { condition }.count` with `.reduce(0) { $0 + (condition ? 1 : 0) }` (or `.count(where:)` if fully migrated to Swift 6+ sequence tools) to avoid intermediate array allocations and improve memory efficiency, particularly on older iOS/macOS deployment targets.
