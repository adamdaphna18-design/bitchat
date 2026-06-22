## 2024-06-18 - Avoid array allocations with .filter in Swift
**Learning:** Chaining `.filter { ... }.count`, `.filter { ... }.first`, or `.filter { ... }.isEmpty` creates intermediate array allocations.
**Action:** Use `.reduce(0)`, `.first(where:)`, and `.contains(where:)` respectively for optimal memory efficiency.
