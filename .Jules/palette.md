## 2024-05-30 - Dynamic State-Dependent Accessibility Labels
**Learning:** In SwiftUI, when a button's functionality and visual state toggles dynamically (e.g., play/pause media controls), VoiceOver requires the accessibility label to update accordingly. A static label can become misleading when the state changes.
**Action:** When adding accessibility labels to buttons with dynamic icons or actions (like `Image(systemName: isPlaying ? "pause" : "play")`), always use a dynamic string or a ternary operator that correctly matches the visual and functional state.
