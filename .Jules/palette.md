## 2024-05-14 - Missing Accessibility Labels on Icon-Only Media Controls
**Learning:** Icon-only buttons used for media controls (like voice note playback, canceling image/voice note sends) frequently lack `.accessibilityLabel` modifiers in this app's components, making them completely opaque to screen readers.
**Action:** When working on or reviewing custom media or complex custom components, explicitly verify that all icon-only interactions have `.accessibilityLabel` and, if appropriate, `.accessibilityHint` modifiers applied.
