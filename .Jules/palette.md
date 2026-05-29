## 2026-05-29 - SwiftUI Accessibility Labels for Dynamic Image Buttons
**Learning:** In SwiftUI, when a button's content dynamically changes (e.g., between a 'play' and 'pause' icon), the `.accessibilityLabel` must also be dynamic to match the current visual state.
**Action:** Always check if a button's icon uses a ternary operator or state variable, and apply the same logic to its `.accessibilityLabel`.
