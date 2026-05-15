## 2024-05-19 - Swift String Methods & Memory Allocations
**Learning:** Checking for substrings using `content.lowercased().contains("str")` creates entirely new string instances in memory. When used in hot paths like message formatters or UI rendering, this leads to unnecessary memory allocations and garbage collection overhead.
**Action:** Always prefer native string matching like `content.range(of: "str", options: .caseInsensitive) != nil` when doing case-insensitive substring checks.

## 2024-05-19 - Regex Compilation Overhead
**Learning:** Using `replacingOccurrences(of: options: .regularExpression)` in Swift compiles the regular expression at runtime every single time the method is called. For simple string operations (like collapsing multiple whitespace characters), the setup time for the regex far exceeds the time it takes to perform the action natively.
**Action:** Avoid runtime regex compilation in hot paths, such as deduplication or formatting engines. Prefer simple `.components(separatedBy:).filter { !$0.isEmpty }.joined(separator: " ")` over string-based regex substitutions.
