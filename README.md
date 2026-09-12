# MyWatchlist

Minimalist offline-first tracker for Anime, Movies, and Series built with Flutter. 
Designed as a private, lightweight alternative to Letterboxd and MyAnimeList.

## Features

- **3 Separate Collections**: Keep your Anime, Movies, and TV Series in dedicated, independent lists.
- **Auto-fill Metadata**: Instantly fetch titles, genres, release years, episodes, and posters using Jikan API (Anime) and TMDB API (Movies/Series).
- **100% Offline-First**: All data and downloaded posters are stored locally on your device. No account, no login, no constant internet required.
- **Track Progress**: Stepper for episode progress. Ratings unlock automatically when marked as "Completed".
- **Backup & Restore**: Export your entire collection to a single `.json` file and import it anywhere to prevent data loss.
- **Dark Mode UI**: Clean Material 3 design optimized for dark mode.

## Tech Stack

- **Framework**: Flutter (Android)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Database**: Isar Community (Offline NoSQL)
- **Networking**: `http` (Jikan v4 REST API & TMDB v3 REST API)

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/mwatchlist.git
   cd mwatchlist
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

4. Build Release APK:
   ```bash
   flutter build apk --release
   ```
   *(APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`)*

## License
MIT License
