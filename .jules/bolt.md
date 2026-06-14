## 2024-05-24 - Avoid Regex for Whitespace Collapsing in Swift
**Learning:** Using `replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)` in Swift is slow, especially in hot paths like message deduplication, due to regex compilation and execution overhead.
**Action:** Use native string manipulations like `components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")` for faster whitespace collapsing.
