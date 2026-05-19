## 2024-05-19 - Avoid `lowercased().contains` for substring checks
**Learning:** `string.lowercased().contains("substring")` is an anti-pattern in Swift for hot paths (like formatting engines or view models parsing chat content). Calling `.lowercased()` creates an entirely new string allocation in memory.
**Action:** Use `.range(of: "substring", options: .caseInsensitive) != nil` instead to perform in-place case-insensitive checks without intermediate memory allocations.
