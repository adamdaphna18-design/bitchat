## 2024-05-10 - Avoid String Allocation via .lowercased().contains
**Learning:** Checking for substrings using `.lowercased().contains("...")` creates expensive, temporary string copies in memory, which degrades garbage collection/ARC performance on hot paths like UI components and formatting engines.
**Action:** Replace all usage of `.lowercased().contains()` with `.range(of: "...", options: .caseInsensitive) != nil` to enable efficient, in-place string matching without memory reallocations.

## 2024-05-10 - Preserve Readability during Micro-Optimizations
**Learning:** Optimizations like replacing `.filter { ... }.count` with `.reduce(0) { $0 + (... ? 1 : 0) }` technically avoid intermediate array allocation but deeply compromise code readability. Review constraints rejected this change.
**Action:** Avoid micro-optimizations that destroy idiomatic Swift readability. Consider alternatives like `.lazy.filter { ... }.count` instead if avoiding intermediate arrays is absolutely necessary, but default to preserving the original clear `.filter` code unless profiling indicates a genuine bottleneck in the array allocation.
