## 2026-03-30 - Custom Media Controls Require Explicit Accessibility Labels
**Learning:** Icon-only buttons used in complex media views (like custom voice note playback or image reveal overlays) lack inherent semantic meaning to screen readers, making them un-navigable and confusing.
**Action:** Always add explicit `.accessibilityLabel` modifiers to custom icon-only media controls, wrapping localized text in `String(localized: "...", comment: "...")` for VoiceOver support.
