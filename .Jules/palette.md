## 2026-07-02 - Added accessibility labels to media buttons
**Learning:** Icon-only buttons within interactive media views (like `VoiceNoteView` and `BlockRevealImageView`) need explicit `.accessibilityLabel` modifiers. Without them, VoiceOver cannot interpret the buttons automatically.
**Action:** Always add explicit `.accessibilityLabel` modifiers with localized strings to icon-only buttons in interactive media views.
