## 2024-05-24 - Add Accessibility Labels to Icon-Only Buttons in Media Views
**Learning:** Found custom media views (`VoiceNoteView` and `BlockRevealImageView`) with icon-only buttons for play/pause and cancel actions that lacked `accessibilityLabel` modifiers, making them difficult for VoiceOver users to interact with.
**Action:** When creating or modifying custom SwiftUI views with buttons that only contain images/icons, always append an `.accessibilityLabel(String(localized:...))` to provide context for screen readers.
