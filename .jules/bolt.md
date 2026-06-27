## 2024-05-14 - Replaced .filter { }.count with .reduce(0)
**Learning:** In Swift, chaining `.filter { ... }.count` creates intermediate array allocations which wastes memory and slows down execution, especially on hot paths like BLE service connection checks.
**Action:** Replace `.filter { ... }.count` with `.reduce(0) { $0 + ($1... ? 1 : 0) }` for optimal memory efficiency and counting, matching project guidelines to avoid intermediate sequences.
