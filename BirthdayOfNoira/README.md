# Curated Celebration (Flutter)

A Flutter port of the "Curated Celebration" birthday-surprise reveal page,
using the same Cerulean/Royal-Blue design system (`DESIGN.md`) as the
original HTML.

## What's included
- `lib/main.dart` — app entry point & theme
- `lib/theme/` — colors and type scale ported from DESIGN.md
- `lib/screens/home_screen.dart` — hero section, unlock button → full-screen
  photo slideshow → reveal message card, WhatsApp action buttons, bottom
  nav, lifecycle-aware music
- `lib/widgets/photo_slideshow.dart` — Instagram-story-style full-screen
  photo sequence (Ken Burns zoom, crossfade, top progress bars, tap
  left/right to go back/skip a photo, "Skip" button to jump straight to
  the letter) shown after tapping Unlock and before the letter
- `lib/widgets/pulsing_button.dart` — pulsing "Unlock Surprise" button
- `lib/widgets/balloon_widget.dart` — rising/fading balloon celebration,
  spawned once the letter appears (matches the original JS behavior)
- `assets/icon/icon.png` — your uploaded "Happy Birthday" graphic, used as
  both the app icon (`flutter_launcher_icons`) and the splash screen image
  (`flutter_native_splash`)
- `assets/audio/birthday_song.mp3` — your uploaded song (audio track only,
  extracted and compressed from the original 21MB video to ~3.7MB)
- `assets/photos/photo1.jpg` … `photo7.jpg` — your 7 uploaded photos, shown
  in that order during the slideshow
- `assets/portrait/portrait.jpg` — the hero portrait shown on the first
  screen, right after the splash

## Setup

```bash
flutter pub get

# Generate the app icon (Android/iOS/web/macOS/Windows):
dart run flutter_launcher_icons

# Generate the native splash screen (shows the birthday icon on launch):
dart run flutter_native_splash:create

flutter run
```

> This project was generated in a sandbox without Flutter/pub.dev access,
> so the commands above haven't been executed yet — run them locally once
> you copy the project over.

## The reveal flow
1. **Hero** — portrait + "Unlock Surprise" button (music is already
   playing in the background by this point, started right after the
   splash screen).
2. **Photo slideshow** — tapping Unlock takes over the full screen and
   plays through your 7 photos (~2.6s each, with a slow zoom and
   crossfade), Instagram-story style, with progress bars up top. Tap the
   left/right half of the screen to go back/skip a photo, or hit "Skip"
   to jump straight to the letter.
3. **The letter** — once the last photo's dwell time elapses (or Skip is
   tapped), the message card, balloons, and the "I am satisfied" /
   "It is not enough..." buttons appear exactly as before.

## How the music behaves
- **Starts right after the splash screen.** The native splash (birthday
  icon) is shown by the OS until Flutter renders its first frame, so the
  song is kicked off in a post-frame callback in `home_screen.dart` —
  effectively "as soon as the splash screen finishes."
- **Pauses when she leaves the app** (switches apps, backgrounds it, or
  the phone locks) via a `WidgetsBindingObserver` watching
  `AppLifecycleState`. This is implemented as pause/resume rather than a
  hard stop, so if she comes back to the app the song picks up where it
  left off instead of restarting from zero — let me know if you'd rather
  it truly reset to the beginning each time.
- **Stops for good** when the app is closed/disposed.
- If the platform blocks autoplay on first launch, tapping "Unlock
  Surprise" will retry starting it.

## If you hit a build crash like `Dart_DetectNullSafety ... Out of memory`
This is the Dart compiler running out of memory during the Gradle build,
usually from a low-memory build machine (not a bug in this code). To fix:
1. In your existing project's `android/gradle.properties`, add/raise:
   ```
   org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=1024m
   ```
2. Close other heavy apps and re-run `flutter clean && flutter pub get && flutter run`.
3. If it still crashes, check Windows' pagefile/virtual memory size isn't
   capped too low (System > Advanced > Performance Settings > Virtual Memory).

## Clearing old/corrupted Gradle downloads
See the commands provided separately in chat — run them from a terminal
opened at your project folder (`android/gradle.properties` etc. must
still exist afterwards; only the caches get deleted).

## Notes / things to double check
- **Portrait photo**: still loads from the original Google-hosted URL used
  in the HTML. Replace with a local asset if you'd rather bundle it.
- **WhatsApp number**: the two reaction buttons deep-link to
  `wa.me/243977853370` exactly as in the source HTML — update if needed.
- Fonts (Playfair Display, Source Sans 3) are pulled via `google_fonts`,
  which downloads them at runtime; for offline/App Store builds you may
  want to bundle them as local assets instead.
