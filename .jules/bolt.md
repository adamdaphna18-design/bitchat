## 2024-05-18 - Avoid lowercased().contains() for substring checks
**Learning:** Using `.lowercased().contains()` creates expensive string memory allocations, especially in hot paths like message formatting or parsing.
**Action:** Use `.range(of: options: .caseInsensitive) != nil` instead for case-insensitive substring checks to avoid the overhead of copying and allocating new strings.
