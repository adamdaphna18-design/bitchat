## 2024-06-07 - Avoid `.lowercased().contains()` in Swift
**Learning:** `content.lowercased().contains("string")` causes expensive string memory allocations for every check because `.lowercased()` creates a whole new string before calling `.contains()`. This is particularly bad in hot paths like message formatting or parsing loops.
**Action:** Always use `content.range(of: "string", options: .caseInsensitive) != nil` instead of `.lowercased().contains()` for substring checks in Swift to completely avoid the string allocation overhead.
