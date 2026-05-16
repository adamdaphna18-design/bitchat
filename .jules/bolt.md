## 2026-05-16 - Swift String Allocation Optimization
**Learning:** In Swift, using `.lowercased().contains()` in hot paths (like parsing chat messages or directory entries) causes performance bottlenecks because `.lowercased()` creates an entirely new String allocation in memory before performing the comparison.
**Action:** Avoid `.lowercased().contains()` for case-insensitive substring checks. Always use `.range(of: options: .caseInsensitive) != nil` instead to perform in-place lookups without allocating extra memory.
