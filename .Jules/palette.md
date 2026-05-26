## 2026-05-26 - VoiceOver Labels for Media Controls
**Learning:** Icon-only buttons for custom media players (like voice notes and image transfers) completely fail VoiceOver if they don't have explicit accessibility labels. SwiftUI's `Image(systemName:)` doesn't provide sufficient context on its own.
**Action:** Always add dynamic `.accessibilityLabel` modifiers (using plain English localized strings) to custom play/pause and cancel buttons in media views.
