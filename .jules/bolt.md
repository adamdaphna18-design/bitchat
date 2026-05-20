## 2024-06-11 - Swift String Allocation Bottleneck
**Learning:** In Swift, using `.lowercased().contains()` for case-insensitive substring checks creates an entire new lowercased copy of the string in memory. On hot paths (like parsing every incoming message or processing large lists), this causes significant memory allocation and garbage collection overhead.
**Action:** Always use `.range(of: options: .caseInsensitive) != nil` instead. It performs the search efficiently without allocating a new string object.
