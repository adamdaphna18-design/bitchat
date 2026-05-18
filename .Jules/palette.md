## 2024-04-10 - Custom Media Views Lack Accessibility
**Learning:** In SwiftUI, VoiceOver treats custom UI components (like VoiceNoteView, BlockRevealImageView, and WaveformView) as generic elements or reads their raw system image names unless explicit accessibility modifiers (`.accessibilityLabel`) are provided.
**Action:** Always add `.accessibilityLabel` to icon-only buttons (`Image(systemName:)`) inside custom components to maintain VoiceOver support.
