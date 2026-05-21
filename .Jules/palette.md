## 2024-05-21 - VoiceOver Accessibility for Media Controls
**Learning:** Custom media controls (like icon-only buttons) and visual components (like Canvas) require explicit `accessibilityLabel` and `accessibilityElement(children: .ignore)` in SwiftUI, otherwise VoiceOver ignores them or reads them unpredictably.
**Action:** Always add accessibility labels to icon-only buttons and group complex custom drawings for VoiceOver using `.accessibilityElement(children: .ignore)`.
