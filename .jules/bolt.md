## 2024-05-18 - Avoid Regex in Hot Paths
**Learning:** In Swift, `replacingOccurrences(of: options: .regularExpression)` is extremely slow due to regex compilation and execution overhead, especially in hot paths like message deduplication or parsing.
**Action:** Replace `replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)` with `components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")` to improve performance.
