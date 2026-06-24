## 2026-06-24 - Dynamic Accessibility Labels for Icon Buttons
**Learning:** For SwiftUI buttons whose icons change based on state (like Play vs Pause in VoiceNoteView), their accessibility labels must also dynamically evaluate the state so VoiceOver correctly reads the current action instead of a generic or static label.
**Action:** Always wrap state-dependent accessibility labels in conditional logic (e.g., `String(localized: isPlaying ? "Pause" : "Play", comment: "...")`) and bind them directly to the Button.
