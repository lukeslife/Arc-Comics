Arc Comics

A fast, elegant, offline-capable Komga comic reader built in Flutter.

Arc Comics is a from-the-ground-up rewrite of a personal comic-reading app—built to deliver a smooth, premium experience across iOS, Android, desktop, and web. It integrates with any Komga server, supports local caching for offline reading, and already includes a functional settings system and polished UI.

This is the v2 generation of the app, focusing on modern architecture, clean state management, and great UX.

✨ Features (Currently Implemented)
🔗 Komga Integration

Arc Comics connects to any Komga instance and supports:

Login with base URL + credentials

Fetching libraries, series, books, and metadata

Fetching page lists and page image bytes

Reading progress stored locally

Automatic thumbnail + page caching

📚 Library UI

The library experience is already functional:

Grid views for series

Book lists per series

Series metadata display

Covers + titles + publisher metadata

Tap a book → open in reader

Publisher information is stored and can be used later for smart shelves.

📖 Comic Reader (Complete & Working)

The reader provides:

Smooth horizontal swiping via PageView

Tap zones for quick next/previous navigation

Zooming + panning with InteractiveViewer

Page fit modes (Contain, Fit Width, Fit Height)

Local caching of pages as they're loaded

Prefetching next page for instant transitions

Respect for Wi-Fi-only streaming

Reading progress stored in Isar

This is already fast, stable, and pleasant to use.

⚙️ Settings Screen (Complete)

A dedicated settings page is implemented, backed by Isar:

Page Fit Mode

Tap Zones: on/off

Wi-Fi-only streaming

Prefetch next page: on/off

Theme (system/dark/light)

Storage usage + clear cache

Future options extensible via SettingsEntity

No mock UI — these settings already persist and affect the reader.

📦 Persistence (Complete)

Using Isar, the app stores:

Series

Books

Pages

Page local paths

Reading progress

User settings

File caching is handled via a custom FileStore service.

🚧 Roadmap (Remaining Work)
1. Home Screen

Inspired by Plex / Netflix:

Continue Reading

Recently Added

Publisher shelves (Marvel / DC / Image, etc.)

Recommendations (“Because you read…”)

Quick access to full library

2. Robust Download System

The base infrastructure is built (DownloadService + progress providers).
Next steps:

Book download UI

Multi-book download queue

Background download support

Download badges + progress indicators

3. Reader Enhancements

The base reader is functional, but future upgrades include:

Vertical scroll mode (manga-style)

Double-page spread (landscape)

Page scrubber / slider

Auto-orientation settings

4. Additional UX Polish

Animated transitions

Better error pages

Pull-to-refresh UX in lists

Custom themes / colors

📁 Project Structure
lib/
 ├─ data/
 │   ├─ api/               # Komga API logic
 │   ├─ repos/             # Repository layer combining API + DB
 │   ├─ storage/           # FileStore (page & cover caching)
 │
 ├─ domain/
 │   ├─ models/            # Isar models (Series, Book, Page, Settings)
 │   ├─ services/          # Download service, utilities
 │
 ├─ features/
 │   ├─ auth/              # Login UI + state
 │   ├─ library/           # Series view, book view, browsing
 │   ├─ reader/            # Reader UI (page view, caching)
 │   ├─ settings/          # Settings screen (completed)
 │
 ├─ routing/               # App router (GoRouter)
 └─ main.dart              # App entrypoint

🔧 Development Setup
Requirements

Flutter 3.16+

Dart 3.2+

iOS: Xcode 15+

Android: Android SDK 34

macOS/Windows/Linux optional

Clone & Run
git clone https://github.com/lukeslife/Arc-Comics.git
cd Arc-Comics
flutter pub get
flutter run

Komga Server Config

Pass server details via --dart-define:

flutter run \
  --dart-define=KOMGA_BASE_URL=https://your-server \
  --dart-define=KOMGA_USERNAME=email \
  --dart-define=KOMGA_PASSWORD=your-password

🤝 Contributing

This is a personal but public project — ideas, issues, and PRs are welcome.

📄 License

MIT License.