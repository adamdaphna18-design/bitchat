## 2024-05-24 - Avoiding intermediate array allocations in sequence filtering

**Learning:** When needing to count items in a sequence matching a condition, chaining `.filter { condition }.count` in Swift creates a full intermediate array in memory before getting the count. While Swift 6.0 introduces `count(where:)`, in this project's Swift 5.9 environment, it's more memory-efficient to use `.reduce(0) { $0 + (condition ? 1 : 0) }` to avoid this allocation overhead, which is particularly beneficial in high-frequency paths like BLE connection handling.

**Action:** Prefer `.reduce(0)` over `.filter { ... }.count` to count conditionally matching items to minimize intermediate allocations and GC pressure.
