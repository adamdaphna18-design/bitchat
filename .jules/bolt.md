## 2024-05-19 - String Parsing Allocations
**Learning:** Found multiple instances where strings were duplicated into entirely new memory spaces strictly for the purpose of a case-insensitive search (`.lowercased().contains("str")`). This is highly inefficient, especially in text-parsing engines.
**Action:** Always prefer `.range(of: "str", options: .caseInsensitive) != nil`. It is semantically equivalent, much more memory efficient, and does not require allocating new `String` instances on the heap.
