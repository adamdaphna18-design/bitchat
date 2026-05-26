## 2024-05-24 - Avoid Regex for Whitespace Collapse
**Learning:** `replacingOccurrences(of: options: .regularExpression)` creates slow regex compilation and execution overhead in hot paths in Swift.
**Action:** Use native string manipulations like `components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")` instead.
