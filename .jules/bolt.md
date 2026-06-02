## 2024-05-24 - Avoid `.lowercased().contains()` in Swift
**Learning:** Using `.lowercased().contains()` for case-insensitive substring checks creates expensive and unnecessary string memory allocations in Swift, impacting performance on hot paths like message processing.
**Action:** Always use `.range(of: options: .caseInsensitive) != nil` instead of `.lowercased().contains()` for optimal memory efficiency during case-insensitive checks.
