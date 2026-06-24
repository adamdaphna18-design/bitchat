## 2024-05-24 - Avoid Regex for Simple Whitespace Trimming
**Learning:** In Swift, `replacingOccurrences(of: options: .regularExpression)` is notoriously slow due to regex compilation and execution overhead, especially in hot paths like message deduplication where it's called frequently.
**Action:** Replace `replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)` with native string manipulations like `components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")` to improve performance.
