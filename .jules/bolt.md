## 2024-05-18 - Avoid Intermediate Arrays in Swift Counting
**Learning:** In Swift, chaining `.filter { ... }.count` creates unnecessary intermediate array allocations, which degrades performance and memory usage, especially on hot paths or large collections. While Swift sometimes provides `.count(where:)`, it is not universally compatible across all Sequence types in this Swift 5.9 project.
**Action:** Use `.reduce(0) { $0 + (condition ? 1 : 0) }` when counting elements that match a condition to ensure sequence compatibility and avoid O(N) memory allocation overhead.
