## 2024-05-09 - Missing ARIA/VoiceOver Labels on Icon-only Toggle Buttons
**Learning:** Found a pattern where custom icon-only toggle buttons (like favorites, bookmarks, and media controls) lacked explicit VoiceOver accessibility labels. VoiceOver could not describe their current state accurately because they relied only on changing the visual SF Symbol.
**Action:** Always verify that icon-only buttons with multiple states include a dynamic `.accessibilityLabel` that clearly describes their current function based on state.
