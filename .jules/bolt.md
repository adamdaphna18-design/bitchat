## 2024-05-31 - Avoid `.lowercased().contains()` for substring checks
**Learning:** Using `.lowercased().contains()` creates expensive string memory allocations, especially in hot paths like message formatting where the string can be large.
**Action:** Use `.range(of: options: .caseInsensitive) != nil` instead.
