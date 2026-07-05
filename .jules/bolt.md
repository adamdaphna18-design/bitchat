## 2025-01-20 - Avoid `.lowercased().contains()` String Allocations
**Learning:** In Swift, chaining `.lowercased().contains("string")` for simple substring matching creates unnecessary and expensive intermediate string allocations. This is especially impactful in hot paths like message formatting.
**Action:** Replace `.lowercased().contains()` with `.range(of: "string", options: .caseInsensitive) != nil` to avoid the allocation overhead while maintaining the same logical check.
