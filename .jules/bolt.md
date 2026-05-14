## 2024-06-25 - Avoid Regular Expressions in Swift Hot Paths
**Learning:** In Swift, using `replacingOccurrences(of: options: .regularExpression)` in hot paths (like message deduplication) introduces slow regex compilation and execution overhead.
**Action:** Prefer native string manipulations like `components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")` for simple patterns like collapsing whitespace, especially in frequently called methods.
