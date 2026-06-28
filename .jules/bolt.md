## 2025-02-12 - Swift Regex Performance Overhead
**Learning:** `replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)` is significantly slower in Swift due to regex compilation and matching overhead, especially in hot paths like message deduplication.
**Action:** Use native string manipulations like `components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.joined(separator: " ")` to handle whitespace collapsing for better performance and memory efficiency.
