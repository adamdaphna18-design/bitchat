## 2024-05-14 - String Allocation Overhead in Array Methods and Regex

**Learning:** Using `.filter { ... }.count` and `.lowercased().contains` are common anti-patterns in Swift that create intermediate array allocations and string allocations respectively. Using `replacingOccurrences(of: options: .regularExpression)` in hot paths like `MessageDeduplicationService` causes slow regex compilation and execution overhead.

**Action:** Replace `.filter.count` with `.reduce(0) { $0 + (condition ? 1 : 0) }` (or `.count(where:)` in newer Swift). Replace `.lowercased().contains` with `.range(of: options: .caseInsensitive) != nil`. Replace regex whitespace collapsing with `components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")`.
