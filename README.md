# X-HAL

**Guided breathing for anxious engineers.**

AI is taking your job. The 6 agents you're running now won't help.
The fastest way to calm your nervous system: cyclic sighing. Deep inhale, short inhale, long exhale. 5 minutes. That's it.

HAL is here. Calm down. Exhale. Get back to work, Dave.

## Features

- Menu bar app — always one click (or ⌘⇧X) away
- Cyclic sighing protocol (Stanford/Huberman research)
- Animated breathing orb with phase guidance
- Optional breathing sounds (bring your own WAV files)
- 10-day streak tracker
- Light + Dark mode support
- Apple Silicon native (universal binary)

## Build

```bash
brew install xcodegen
cd X-HAL && xcodegen generate
open X-HAL.xcodeproj
# Build & Run (⌘R)
```

## Sound Files

Drop your WAV files into `X-HAL/Resources/Sounds/`:

- `deep-inhale.wav` — played during the 4s deep inhale
- `short-inhale.wav` — played during the 2s short inhale
- `long-exhale.wav` — played during the 6s long exhale
- `completion.wav` — played when the session finishes

The app works fine without them — sounds are optional.

## Keyboard Shortcut

**⌘⇧X** — Toggle the breathing popover from anywhere.
