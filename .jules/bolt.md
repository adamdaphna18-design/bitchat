## 2024-05-24 - Avoid `.lowercased().contains()` in Swift
**Learning:** Using `.lowercased().contains()` creates a new string allocation every time it's called, which can cause significant memory pressure in hot paths (like parsing chat messages).
**Action:** Replace `.lowercased().contains("string")` with `.range(of: "string", options: .caseInsensitive) != nil` to check for substrings without allocating a new string.
