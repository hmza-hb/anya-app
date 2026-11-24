# Anya App

**This repository is the entire product.** Everything that ships to GitHub and production lives in this folder: Dart code (`lib/`), platform projects (`android/`, `ios/`, `linux/`, `web/`), assets, and tests. There is no separate app root elsewhere.

The Flutter SDK is a **local dev tool** (not committed). This repo pins the version in `mise.toml`.

### One-time setup (recommended — you already have `mise`)

```bash
cd /path/to/anya-app
mise trust          # if mise asks you to trust this config
mise install        # downloads Flutter ~3.50.1 (first time only, several minutes)
flutter doctor
```

`mise` adds `flutter` to your PATH when you are **inside this directory** (ensure your shell loads mise — Omarchy usually does via `~/.config/mise/shims`).

If `flutter` is still not found after `mise install`, run commands via mise explicitly:

```bash
mise exec -- flutter pub get
mise exec -- flutter run -d web-server --web-hostname=localhost --web-port=8080
# then open http://localhost:8080 in Firefox, Chrome, etc.
```

`mise.toml` sets `CHROME_EXECUTABLE` for Arch (`google-chrome-stable`). To launch Chrome directly:

```bash
flutter run -d chrome
```

Do **not** use bare `flutter run` on Linux unless you have CMake/ninja installed — it defaults to the **Linux desktop** target.

Or use the helper script:

```bash
chmod +x scripts/run-web.sh
./scripts/run-web.sh
```

A landscape Flutter companion that shows **Anya**'s OLED-style face with smooth, morphing expressions inspired by the [expression reference sheet](assets/expressions_reference.jpg).

## Run

From this directory:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Use a phone or emulator in **landscape**. The app runs fullscreen (immersive).

### Browser (local)

Enable the web target once if you cloned an older checkout without a `web/` folder:

```bash
flutter create . --platforms=web
```

**Option A — any browser (recommended on Arch):**

```bash
flutter run -d web-server --web-hostname=localhost --web-port=8080
# or: ./scripts/run-web.sh
```

**Option B — Chrome (hot reload):** requires `CHROME_EXECUTABLE` (set in `mise.toml` on Arch):

```bash
flutter run -d chrome
```

Then open [http://localhost:8080](http://localhost:8080). Widen the window or rotate to **landscape** — the layout is built for that aspect ratio.

**Option C — static build + simple server:**

```bash
flutter build web
npx --yes serve build/web -l 8080
```

Right-click on the face for the heart gesture. To preview any state in code, use `AnyaFaceController.setExpression` or the `ExpressionRibbon` widget in `lib/anya/anya_interactions.dart`.

## Build (release)

```bash
flutter build web            # Static files in build/web
flutter build apk          # Android
flutter build ipa          # iOS (macOS + Xcode)
flutter build linux        # Linux desktop
```

## Interactions

Each gesture maps to **one** expression (no doubles).

**Primary finger**

| Gesture | Expression |
|---------|------------|
| Tap | Wink |
| Double tap | Surprised |
| Long press — left / center / right third | Curious / Processing / Proud (release → idle) |
| Flick up | Excited |
| Flick down (gentle) | Sad |
| Flick down (hard) | Angry |
| Flick left (gentle) | Look left |
| Flick left (hard) | Error ✕ |
| Flick right | Look right |

**Right mouse button**

| Gesture | Expression |
|---------|------------|
| Click | In love |
| Hold | Happy |

**Middle mouse button**

| Gesture | Expression |
|---------|------------|
| Click | Accepted ✓ |

Middle button has **no** long-press action (error is not here — use a hard flick left).

“Hard” flick ≈ fast swipe (same threshold for angry and error).

## Expressions

**29** states are defined on `AnyaExpression` in `lib/anya/anya_expression.dart`, matching the [reference sheet](assets/expressions_reference.jpg). **13** have locked **masters** (tuned geometry in `lib/anya/masters/*_master.dart`); the rest use placeholder `FaceParams` in `face_params_catalog.dart` until their masters land.

| Expression | Master | Gesture / how to try |
|------------|:------:|----------------------|
| Idle | ✓ | Default; release after long press |
| Happy | ✓ | Right mouse **hold** |
| Sad | ✓ | Gentle flick **down** |
| Excited | ✓ | Flick **up** |
| Curious | ✓ | Long press **left** third |
| Thinking | — | `setExpression` / ribbon |
| Sleepy | — | `setExpression` / ribbon |
| Surprised | ✓ | **Double tap** |
| Winking | ✓ | **Tap** |
| Angry | ✓ | Hard flick **down** |
| In love | ✓ | Right mouse **click** |
| Accepted | ✓ | Middle mouse **click** |
| Speaking | — | Catalog (sound waves) |
| Listening | — | Catalog (sound waves) |
| Shy | — | Catalog (blush + arch) |
| Proud | ✓ | Long press **right** third |
| Look up | — | Catalog (gaze arrow) |
| Look down | — | Catalog (gaze arrow) |
| Look left | — | Gentle flick **left** |
| Look right | — | Flick **right** |
| Thinking hard | — | Catalog (narrow eyes + sparkle) |
| Confused | — | Catalog (slanted eyes + `?`) |
| Listening (active) | — | Catalog (boosted waves) |
| Speaking (active) | — | Catalog (boosted waves) |
| Processing | ✓ | Long press **center** third |
| Connecting | — | Catalog (link icon) |
| Error | ✓ | Hard flick **left** |
| Charging | — | Catalog (battery ~65%) |
| Low battery | — | Catalog (battery ~12%) |

Ambient **blinks** run on idle, happy, sad, curious, excited, angry, and proud.

## Architecture

- **`lib/anya/masters/expression_masters.dart`** — index of all **13** locked masters
- **`lib/anya/masters/idle_master.dart`** — default pill eyes
- **`lib/anya/masters/happy_master.dart`** / **`sad_master.dart`** — thick ∩ / ∪ semicircle arches
- **`lib/anya/masters/curious_master.dart`** — `?` on right eye
- **`lib/anya/masters/surprised_master.dart`** — wider eyes, `!` + `?`
- **`lib/anya/masters/winking_master.dart`** — curious + shortened right eye
- **`lib/anya/masters/excited_master.dart`** — animated `> <` brackets
- **`lib/anya/masters/in_love_master.dart`** — centered heart
- **`lib/anya/masters/accepted_master.dart`** / **`error_master.dart`** — animated ✓ / ✕
- **`lib/anya/masters/angry_master.dart`** — filled slanted eyes
- **`lib/anya/masters/proud_master.dart`** — happy eyes + sparkle stars
- **`lib/anya/masters/processing_master.dart`** — eight-dot spinner ring
- **`lib/anya/masters/eye_glow_style.dart`** — shared lavender glow
- `lib/anya/face_params.dart` — numeric face state (everything lerps)
- `lib/anya/anya_face_painter.dart` — custom painter with glow strokes
- `lib/anya/anya_face_controller.dart` — morphing, blinks, idle curiosity
- `lib/anya/anya_interactions.dart` — gesture → expression mapping

Expressions transition with ~480ms cubic easing so shapes feel continuous rather than hard cuts.