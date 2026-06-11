## 2024-06-11 - Dynamic Accessibility Labels for SwiftUI Buttons
**Learning:** When a button's content changes dynamically based on state (e.g., a play/pause icon toggling based on `playback.isPlaying`), the `.accessibilityLabel` must also use a ternary or conditional to accurately reflect the current state to VoiceOver users.
**Action:** Always conditionally update `.accessibilityLabel` to match dynamic visual states in SwiftUI to ensure VoiceOver stays synchronized.
