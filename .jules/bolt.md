## 2024-05-24 - In-place array mutation to avoid array reallocations
**Learning:** `items.filter` creates a new array regardless of whether a filter actually modifies the elements. Calling this in a loop across all chat instances causes severe performance degradations and unnecessary memory allocations when there is no need to create a copy.
**Action:** Use `.firstIndex(where:)` to search, and `items.remove(at:)` to mutate the array in place instead of filtering the entire array.
