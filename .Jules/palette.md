## 2024-05-24 - Missing accessibility labels on custom media controls
**Learning:** Icon-only buttons used for custom media controls (like inline voice note playback/cancellation or image reveal cancellation) often lack `.accessibilityLabel` modifiers, making them invisible or meaningless to VoiceOver users.
**Action:** When creating or modifying complex media views with custom controls, explicitly verify that all icon-only buttons include localized `.accessibilityLabel` modifiers describing their specific action (e.g., "Play voice note", "Cancel sending image").
