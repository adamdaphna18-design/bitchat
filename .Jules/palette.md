## 2024-05-24 - Missing accessibility labels on media control buttons
**Learning:** Found that VoiceNoteView and BlockRevealImageView are missing accessibility labels for their play/pause and cancel buttons, making them completely opaque to VoiceOver users. Since these are icon-only buttons, VoiceOver just reads them as "Button".
**Action:** Always add explicit .accessibilityLabel with plain English text (wrapped in String(localized:)) to icon-only buttons like media controls, especially inside complex nested components like voice notes or media previews.
