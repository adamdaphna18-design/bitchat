## 2024-05-24 - Intermediate Array Allocations in Hot Paths
**Learning:** In Swift, chaining `.filter { ... }.count` creates an intermediate array containing all matching elements just to count them, which causes unnecessary memory allocations and CPU overhead, especially in frequently executed code like Bluetooth state checks (`BLEService.swift`).
**Action:** Replace `.filter { ... }.count` with `.reduce(0) { $0 + (condition ? 1 : 0) }` to count elements in O(n) time and O(1) space, avoiding array allocations.
