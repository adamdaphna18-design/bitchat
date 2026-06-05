## 2024-10-27 - Swift Collection Memory Efficiency
**Learning:** In Swift, chaining `.filter { ... }.count` on collections (especially frequent accesses in tight loops or network callbacks like in `BLEService`) causes unnecessary intermediate array allocations, triggering expensive memory overhead.
**Action:** Replace `.filter { ... }.count` with `.reduce(0) { $0 + (condition ? 1 : 0) }` (or natively `.count(where:)` in newer Swift versions if appropriate). For Swift 5.9, using `.reduce(0)` prevents intermediate memory allocations while fulfilling exactly the same condition checks.
