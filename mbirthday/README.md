# Curated Celebration (Flutter)

A Flutter port of the "Curated Celebration" birthday-surprise reveal page,
using the same Cerulean/Royal-Blue design system (`DESIGN.md`) as the
original HTML.

## What's included
- `lib/main.dart` — app entry point & theme
- `lib/theme/` — colors and type scale ported from DESIGN.md
- `lib/screens/home_screen.dart` — hero section, unlock button, reveal
  message card, WhatsApp action buttons, bottom nav
- `lib/widgets/pulsing_button.dart` — pulsing "Unlock Surprise" button
- `lib/widgets/balloon_widget.dart` — rising/fading balloon celebration,
  spawned for ~15s after unlocking (matches the original JS behavior)
- `assets/icon/icon.png` — your uploaded "Happy Birthday" graphic, wired
  up as the app icon via `flutter_launcher_icons`

## Setup

```bash
flutter pub get

# Generate the app icon (Android/iOS/web/macOS/Windows) from assets/icon/icon.png:
dart run flutter_launcher_icons

flutter run
```

> This project was generated in a sandbox without Flutter/pub.dev access,
> so the commands above haven't been executed yet — run them locally once
> you copy the project over.

## Notes / things to double check
- **Audio**: the birthday song still points at the original SoundHelix demo
  URL. Swap `_birthdaySongUrl` in `home_screen.dart` for your own track.
- **Portrait photo**: still loads from the original Google-hosted URL used
  in the HTML. Replace with a local asset if you'd rather bundle it.
- **WhatsApp number**: the two reaction buttons deep-link to
  `wa.me/243977853370` exactly as in the source HTML — update if needed.
- Fonts (Playfair Display, Source Sans 3) are pulled via `google_fonts`,
  which downloads them at runtime; for offline/App Store builds you may
  want to bundle them as local assets instead.
