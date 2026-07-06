## 2024-05-18 - Explicit accessibility labels on generic views
**Learning:** Custom SwiftUI media views in Bitchat (like VoiceNoteView, BlockRevealImageView) rely on internal generic views (e.g. icon-only buttons) which must have explicit `.accessibilityLabel` modifiers to prevent them from becoming opaque to screen readers. Wrap plain text localized strings in `String(localized: "...", comment: "...")`.
**Action:** Always add explicit, conditionally dynamic `.accessibilityLabel`s with `String(localized:)` when creating or modifying icon-only interactive components.
