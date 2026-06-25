## 2024-06-12 - Prevent Swift O(N) Array Allocations on Counting
**Learning:** Chaining `.filter { ... }.count` in Swift eagerly allocates an intermediate array just to calculate the count, which causes unnecessary memory pressure and garbage collection overhead, particularly in hot paths like connection loops.
**Action:** Replace `.filter { ... }.count` with `.reduce(0) { $0 + (... ? 1 : 0) }` (or `.lazy.filter { ... }.count`) to count elements in-place with O(1) memory overhead.
