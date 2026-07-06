## 2024-05-18 - String Case-Insensitive Search Optimization
**Learning:** In Swift, using `.lowercased().contains("string")` for substring checks creates expensive string memory allocations due to intermediate lowercased string creation.
**Action:** Use `.range(of: "string", options: .caseInsensitive) != nil` instead to perform substring checks without memory allocations.
