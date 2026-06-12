## 2024-06-12 - Intermediate Array Allocation in Swift Sequence Counting
**Learning:** In Swift, chaining `.filter { ... }.count` to count occurrences in a sequence (like `Array` or `Dictionary.Values`) creates an unnecessary, intermediate array allocation. In hot paths, such as connection budgeting (`BLEService.swift`), this increases memory pressure and overhead.
**Action:** Replace `.filter { condition }.count` with `.reduce(0) { $0 + (condition ? 1 : 0) }` (or `.lazy.filter { ... }.count` for clarity) to perform the count in-place with O(1) memory overhead.
