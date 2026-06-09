## 2024-05-18 - Avoid String Allocation in Contains Search
**Learning:** In Swift, using `.lowercased().contains("str")` creates an expensive new string instance. This was discovered in the hot paths `ChatViewModel.swift` and `MessageFormattingEngine.swift` which heavily process and format strings for rendering.
**Action:** Replace `.lowercased().contains("str")` with `.range(of: "str", options: .caseInsensitive) != nil` to perform an allocation-free case-insensitive substring search.
