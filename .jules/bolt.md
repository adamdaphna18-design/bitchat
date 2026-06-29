## 2024-05-19 - Swift String Substring Check Performance
**Learning:** In Swift, chaining `.lowercased().contains()` creates intermediate array allocations for the newly lowercased string. This is particularly expensive when parsing large messages or processing multiple lines of text (e.g., in `MessageFormattingEngine` and `ChatViewModel`).
**Action:** Always prefer `.range(of: String, options: .caseInsensitive) != nil` over `.lowercased().contains(String)` for case-insensitive substring checks, as it performs the check in-place without generating a new intermediate string allocation.
