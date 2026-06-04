## 2024-06-04 - VoiceOver Accessibility for Complex Media Components
**Learning:** Custom, purely visual SwiftUI components like WaveformView can create unnecessary noise for VoiceOver users, and icon-only buttons need conditionally dynamic labels to correctly mirror state changes.
**Action:** When implementing custom media controls or interactive charts:
1. Always apply `.accessibilityElement(children: .ignore)` alongside a custom `.accessibilityLabel` and `.accessibilityValue` to the parent wrapper of complex canvas/path drawings.
2. For toggle buttons (like play/pause), use a ternary operator inside the `.accessibilityLabel` to update the spoken text dynamically (e.g., `playback.isPlaying ? "Pause" : "Play"`) to maintain correct state context for VoiceOver.