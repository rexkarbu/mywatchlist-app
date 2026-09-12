# MyWatchlist

A minimalist, offline-first personal tracker for **Anime**, **Movies**, **Series**, and **Reading** (Manga, Manhwa, Manhua, Light Novel) built with Flutter. Designed as a private, lightweight, distraction-free alternative to Letterboxd, MyAnimeList, and AniList.

---

## ✨ Features

- **4 Separate Collections**: Dedicated, independent tabs for **Anime**, **Movies**, **Series**, and **Reading**.
- **Auto-fill Metadata Online**:
  - **Anime & Reading**: Powered by **AniList GraphQL API** (`graphql.anilist.co`) — fast, 100% free, and requires no API key. Automatically fetches titles (English/Romaji), release year, genres, total episodes/chapters, format (`MANGA`, `NOVEL`, etc.), and high-resolution posters.
  - **Movies & Series**: Powered by **The Movie Database (TMDB) API** with rich Indonesian & English metadata, posters, and overviews.
- **100% Offline-First**: All your data and downloaded posters are stored locally on your device using the lightning-fast Isar NoSQL database. No account, no sign-in, and no internet required for everyday use.
- **Dynamic Progress Tracking**:
  - **Episodes** tracker with quick +/- steppers for Anime & Series.
  - **Chapters / Volumes** tracker for Manga, Manhwa, and Light Novels.
  - Smart rating unlock: 1–10 star rating bar unlocks automatically when an item is marked as "Completed".
- **JSON Backup & Restore**: Export your entire database into a clean JSON backup file to easily share or restore your watchlist on a new device.
- **Statistics Dashboard**: Summary overview of total collection count, completion rates, and average rating breakdown per category.
- **Material 3 Dark Theme**: Sleek dark UI with modern Inter typography and custom launcher icon.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Android SDK)
- **State Management**: [Riverpod](https://riverpod.dev) (`flutter_riverpod`)
- **Local Database**: [Isar Community](https://github.com/isar-community/isar) (Fast embedded NoSQL engine)
- **Networking**: `http` (AniList GraphQL API & TMDB REST API)
- **Asset & Icons**: `flutter_launcher_icons`

---

## 📥 Download APK

You can download the ready-to-install Android APK directly from the Releases page:

👉 **[Download Latest APK (`app-release.apk`)](https://github.com/rexkarbu/mywatchlist-app/releases/download/v1.0.0/app-release.apk)**

---

## 🚀 Getting Started (Development)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rexkarbu/mywatchlist-app.git
   cd mywatchlist-app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **(Optional) Configure TMDB API Key:**
   To enable online auto-fill for Movies and Series, get a free API key from [themoviedb.org](https://www.themoviedb.org/settings/api) and paste it in `lib/services/tmdb_api_service.dart`:
   ```dart
   static const String defaultApiKey = 'YOUR_TMDB_API_KEY';
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

5. **Build Release APK:**
   ```bash
   flutter build apk --release
   ```
   *(The generated APK will be at `build/app/outputs/flutter-apk/app-release.apk`)*

---

## 📄 License

Distributed under the [MIT License](LICENSE).
