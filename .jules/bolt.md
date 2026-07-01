## 2024-05-01 - Avoid Regex for basic whitespace collapsing
**Learning:** Using `.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)` in Swift is slow on hot paths due to regex compilation and execution overhead.
**Action:** Replace it with the native `trimmed.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")` to improve performance without adding dependencies.
