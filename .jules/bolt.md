## 2024-05-18 - String Lowercasing Allocations in Substring Checks
**Learning:** In Swift, using `.lowercased().contains("substring")` for case-insensitive substring checks is an anti-pattern that creates expensive and unnecessary intermediate string memory allocations, especially impactful on hot paths like text rendering and chat filtering.
**Action:** Always prefer `.range(of: options: .caseInsensitive) != nil` instead of `.lowercased().contains()` to avoid memory bloat and execution overhead.
