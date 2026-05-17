## 2024-05-18 - Avoid String Allocation Overhead with .range(of:)
**Learning:** Using `.lowercased().contains("string")` in Swift, especially in hot paths like message formatting heuristics or line-by-line CSV parsing, creates significant memory overhead. Each call to `.lowercased()` allocates an entirely new String in memory before doing the substring search.
**Action:** Always use `.range(of: "string", options: .caseInsensitive) != nil` instead. This performs the case-insensitive search in-place without allocating a new string object.
