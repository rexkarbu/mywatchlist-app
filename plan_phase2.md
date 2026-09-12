# Rencana Pengembangan Phase 2: Integrasi API Auto-fill Metadata

## 1. Konsep & Tujuan
Menambahkan fitur **Auto-fill Metadata Online** saat menambah atau mengedit item tontonan di aplikasi **MWatchlist**. 

Pengguna dapat mencari judul secara online, memilih hasil yang paling sesuai, dan aplikasi akan secara otomatis mengisikan:
- Judul resmi
- Tahun rilis
- Daftar Genre
- Total Episode (khusus Anime) atau Total Season/Episode (khusus Series)
- Poster otomatis (diunduh dan disimpan ke penyimpanan lokal HP)
- Catatan / Sinopsis singkat (opsional)

---

## 2. Sumber Data API

1. **Anime** → **Jikan API v4** *(Unofficial MyAnimeList API)*
   - **Endpoint**: `https://api.jikan.moe/v4/anime?q={query}&limit=10`
   - **Ketentuan**: Gratis, tanpa API Key.
   - **Rate Limit**: Maksimal 3 request/detik (gunakan *debouncing* ~500ms pada pencarian).

2. **Film & Series** → **TMDB API v3** *(The Movie Database)*
   - **Endpoint Film**: `https://api.themoviedb.org/3/search/movie?query={query}&language=id-ID`
   - **Endpoint Series**: `https://api.themoviedb.org/3/search/tv?query={query}&language=id-ID`
   - **Ketentuan**: Gratis, membutuhkan **TMDB API Key** (disimpan di file konfigurasi/constant).
   - **Base Image URL**: `https://image.tmdb.org/t500/{poster_path}`

---

## 3. Komponen & Struktur Berkas Baru

```text
lib/
├── models/
│   └── api_search_result.dart       # Model terpadu untuk hasil pencarian online (Jikan & TMDB)
├── services/
│   ├── jikan_api_service.dart       # HTTP client & parser Jikan API (Anime)
│   └── tmdb_api_service.dart        # HTTP client & parser TMDB API (Film & Series)
├── providers/
│   └── api_search_provider.dart     # Riverpod Family Provider + Debouncing pencarian
├── widgets/
│   └── api_search_dialog.dart       # Modal Bottom Sheet / Dialog UI pencarian metadata online
└── screens/
    └── add_edit_screen.dart         # Integrasi tombol "Cari Online (Auto-fill)"
```

---

## 4. Alur Kerja Pengguna (User Flow)

1. Pengguna membuka layar **Tambah / Edit Item** (`AddEditScreen`).
2. Pengguna menekan tombol **"Cari Online"** di sebelah bidang judul atau di bagian atas form.
3. Dialog/Bottom Sheet pencarian muncul, langsung mencari sesuai kata kunci yang diisi (atau input baru) sesuai tipe koleksi aktif (**Anime**, **Film**, atau **Series**).
4. Hasil pencarian menampilkan daftar item lengkap dengan **thumbnail poster, judul, tahun, dan info episode/genre**.
5. Pengguna menekan salah satu hasil:
   - Aplikasi mengunduh gambar poster ke direktori lokal HP (`copyPosterToAppDir`).
   - Form secara otomatis terisi dengan data yang diambil dari API.
6. Pengguna dapat menyesuaikan kembali status/catatan, lalu menekan **Simpan**.

---

## 5. Tahapan Eksekusi

1. **Setup Dependency**: Tambahkan package `http` ke `pubspec.yaml`.
2. **Buat Model Unified** `ApiSearchResult`:
   - `title`, `year`, `genres`, `posterUrl`, `totalEpisodes`, `synopsis`.
3. **Buat Service API**:
   - `JikanApiService` untuk parsing JSON dari Jikan.
   - `TmdbApiService` untuk parsing JSON dari TMDB API.
4. **Buat Provider & UI Search Dialog**:
   - `api_search_provider.dart` dengan fitur debounce pencarian.
   - `api_search_dialog.dart` untuk menampilkan list hasil pencarian secara responsif.
5. **Integrasikan ke Form & Image Downloader**:
   - Tambahkan fungsi pengunduh gambar dari URL ke local storage aplikasi di `DatabaseService`.
   - Hubungkan callback dari dialog pencarian ke controller form di `AddEditScreen`.
6. **Pengujian Unit & Kompilasi**:
   - Uji parsing JSON mock untuk Jikan dan TMDB.
   - Jalankan `flutter analyze` dan `flutter test` untuk memastikan zero regression.

---

## 6. Prompt Siap Kirim ke Antigravity IDE

Copy-paste teks di bawah ini ke chat Antigravity IDE untuk mengeksekusi integrasi ini secara otomatis:

```text
Tolong tambahkan fitur Integrasi API Auto-fill Metadata (Jikan API & TMDB API) pada aplikasi Flutter "MWatchlist".

SPESIFIKASI FITUR:
1. PackageTambahan:
   - Tambahkan package `http` pada pubspec.yaml.

2. Model Terpadu (lib/models/api_search_result.dart):
   - Buat class ApiSearchResult dengan properti: title, year, genres (List<String>), posterUrl, totalEpisodes (int?), synopsis (String?).

3. API Services (lib/services/):
   - `jikan_api_service.dart`: Panggil Jikan v4 API (https://api.jikan.moe/v4/anime?q={query}&limit=10) untuk tipe Anime. Parse judul, tahun rilis, list genre, total episode (episodes), poster (images.jpg.large_image_url), dan synopsis.
   - `tmdb_api_service.dart`: Panggil TMDB v3 API (search/movie dan search/tv) untuk tipe Film & Series. Sediakan konstanta API Key (dengan fallback placeholder yang dapat diisi pengguna). Parse posterUrl dengan prefix https://image.tmdb.org/t500/.

4. Local Poster Downloader (lib/services/database_service.dart):
   - Tambahkan method `downloadPosterToAppDir(String url)` untuk mengunduh gambar dari URL internet dan menyimpannya di direktori lokal app (`posters/`), mengembalikan path lokal baru.

5. Search UI (lib/widgets/api_search_dialog.dart):
   - Tampilkan modal bottom sheet / dialog dengan Search Bar + Debounce (500ms).
   - Tampilkan list hasil berupa Card dengan poster thumbnail, judul, tahun rilis, badge genre, dan total episode jika ada.
   - Tampilkan loading state dan empty state jika tidak ada hasil dari API.

6. Integrasi Form (lib/screens/add_edit_screen.dart):
   - Tambahkan tombol "Cari Online (Auto-fill)" dengan icon `Icons.auto_awesome_rounded`.
   - Saat hasil dipilih dari dialog, panggil downloader gambar poster lalu otomatis isi controller: judul, tahun, genre chips, total episode (khusus anime/series), dan poster lokal path.

7. Verifikasi:
   - Jalankan `flutter analyze` untuk memastikan tidak ada lint error.
   - Jalankan `flutter test` untuk memastikan semua pengujian unit yang ada tetap PASSED.
```
