## 2024-06-25 - Avoid array allocations in intermediate `.filter().count` calls

**Learning:** In Swift, calling `.filter { ... }.count` generates an intermediate array allocation holding all filtered items only to immediately throw it away.
**Action:** Replace calls to `.filter { ... }.count` with `.reduce(0) { $0 + (... ? 1 : 0) }` (or `.count(where:)` if running Swift 6.0+) to skip array allocations. For `.filter { ... }.count > 0`, replace with `.contains { ... }` for O(1) early exit support.
