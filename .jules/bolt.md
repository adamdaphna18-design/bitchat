## 2025-01-29 - Optimize Swift Substring Checks
**Learning:** Using `.lowercased().contains("foo")` for case-insensitive substring checks triggers expensive memory allocations in Swift because `.lowercased()` allocates a new string before searching. This becomes a performance issue in hot paths like message formatting.
**Action:** Always use `.range(of: "foo", options: .caseInsensitive) != nil` instead of `.lowercased().contains("foo")` to avoid unnecessary allocations.
