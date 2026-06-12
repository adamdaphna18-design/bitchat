## 2024-05-18 - Missing Accessibility Labels on Media Buttons
**Learning:** Found multiple icon-only buttons in Media views (VoiceNoteView, BlockRevealImageView) lacking `.accessibilityLabel`. VoiceOver users wouldn't know what these buttons do (e.g., "play/pause" or "cancel").
**Action:** Adding explicit `.accessibilityLabel` to these buttons with localized strings.
