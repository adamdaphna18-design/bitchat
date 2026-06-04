## 2024-05-24 - Optimize Case-Insensitive Substring Search
**Learning:** In Swift, using `.lowercased().contains()` for substring checks creates expensive intermediate string memory allocations, particularly in hot paths like message rendering and formatting.
**Action:** Use native string method `.range(of: options: .caseInsensitive) != nil` instead for optimal memory efficiency and reduced allocation overhead.
