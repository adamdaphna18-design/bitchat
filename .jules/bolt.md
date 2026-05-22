## 2026-05-22 - Replaced .lowercased().contains() with .range(of: options: .caseInsensitive) != nil
**Learning:** In Swift, `.lowercased().contains()` for substring checks is inefficient because it creates expensive string memory allocations for the entire lowercased string.
**Action:** Use `.range(of: options: .caseInsensitive) != nil` instead to avoid intermediate allocations and improve performance, especially in hot paths like message rendering.
