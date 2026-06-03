## 2024-05-30 - Regex Overheads
**Learning:** In Swift, `replacingOccurrences(of: options: .regularExpression)` is significantly slower than using native string manipulation (`components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")`) due to regex compilation and execution overhead.
**Action:** Replace `replacingOccurrences(of: options: .regularExpression)` with native string splitting and joining for simple whitespace collapse operations.
