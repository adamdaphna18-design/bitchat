## 2024-06-20 - Media Views Accessibility

**Learning:** Purely visual components conveying progress or meaning (like custom waveform visualizations in `WaveformView`) will be read out disjointly and nonsensically by VoiceOver.
**Action:** Use `.accessibilityElement(children: .ignore)` to bundle these visualizations into a single coherent block, then provide context with an `.accessibilityLabel` and dynamic `.accessibilityValue`.

## 2024-06-20 - Dynamic Media Button States

**Learning:** Media buttons (like play/pause in `VoiceNoteView`) often swap `Image` content directly without swapping accessibility labels.
**Action:** Always conditionally map the accessibility label to the specific active visual state in media control toggles.
