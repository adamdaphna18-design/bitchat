## 2024-05-18 - Accessible Media Controls
**Learning:** Custom media controls (like play/pause and waveform views) require careful accessibility treatment. VoiceNoteView had unlabelled icon buttons and a complex Canvas-based waveform that VoiceOver couldn't interpret.
**Action:** Always add dynamic `.accessibilityLabel`s to play/pause toggles that update based on state. For complex visual visualizations like waveforms, use `.accessibilityElement(children: .ignore)` on the container, combined with a clear `.accessibilityLabel` and dynamic `.accessibilityValue` to represent progress.
