**# # Rencana Aplikasi: Watchlist Anime, Film & Series (Flutter)

## 1. Konsep & Tujuan

Aplikasi tracker tontonan pribadi, mirip **Letterboxd tapi versi minimalis**, dengan perbedaan utama: **anime, film, dan series dipisah jadi 3 koleksi sendiri-sendiri** (bukan digabung dalam satu list besar). Setiap koleksi punya status tonton dan rating masing-masing.

Target: aplikasi Android, offline-first (semua data tersimpan lokal di HP, tidak butuh akun/server).

## 2. Fitur Utama (MVP)

- **3 koleksi terpisah**: Anime / Film / Series — masing-masing punya list dan tab sendiri
- **Status tonton** per item: `Mau Ditonton`, `Sedang Ditonton`, `Sudah Ditonton`
- **Rating** — skala 1–10 (atau bintang 1–5), hanya aktif setelah status "Sudah Ditonton"
- **Tambah/edit/hapus item** manual: judul, tahun rilis, genre (tag bebas), poster (upload dari galeri atau warna solid default), catatan pribadi
- **Progress episode/season** — khusus Anime & Series (misal "12/24 episode", "Season 2")
- **Filter & sort** dalam tiap koleksi — berdasarkan status, rating, judul (A-Z), tanggal ditambahkan
- **Search** cepat dalam koleksi aktif
- **Detail view** per item — semua info + tombol ubah status/rating cepat
- **Dashboard ringkas** (opsional tapi disarankan) — total ditonton per kategori, rata-rata rating, item yang lagi "Sedang Ditonton"

## 3. Fitur Lanjutan (Phase 2 — opsional, dikerjakan setelah MVP jalan)

- **Auto-fill metadata & poster** via API:
  - Anime → **Jikan API** (unofficial MyAnimeList API, gratis, tanpa API key)
  - Film/Series → **TMDB API** (gratis, butuh API key)
- **Import/export data** (JSON/CSV) buat backup manual
- **Widget home screen** — "sedang nonton apa sekarang"
- **Statistik lebih detail** — grafik jumlah tontonan per bulan, genre favorit
- **Custom list/koleksi tambahan** di luar 3 kategori default (misal "Rewatch", "Drop")

## 4. Struktur Data

Satu model dasar dipakai untuk ketiganya, dibedakan lewat field `type`:

```
WatchItem
- id: String (uuid)
- type: enum (anime, movie, series)
- title: String
- year: int?
- genres: List<String>
- status: enum (planToWatch, watching, completed)
- rating: double? (null sebelum completed)
- posterPath: String? (path lokal file gambar)
- notes: String?
- progressCurrent: int? (episode/season berjalan — khusus anime & series)
- progressTotal: int? (total episode/season — khusus anime & series)
- dateAdded: DateTime
- dateCompleted: DateTime?
```

## 5. Navigasi & Layar

- **Bottom navigation 4 tab**: Anime | Film | Series | Stats
- **List screen** (per tab) — grid poster ala Letterboxd, filter/sort di app bar, search icon, tombol tambah (FAB)
- **Detail screen** — poster besar, info lengkap, tombol ubah status (chip/segmented button), rating picker, tombol edit/hapus
- **Add/Edit screen** — form input (judul, tahun, genre chips, status, progress kalau relevan, catatan, pilih poster dari galeri)
- **Stats screen** — ringkasan angka + breakdown per kategori

## 6. Tech Stack

- **Framework**: Flutter (Android target)
- **State management**: Riverpod
- **Local database**: Isar (cepat, cocok buat model dengan query filter/sort banyak) — alternatif: Hive kalau mau lebih ringan
- **Image handling**: `image_picker` (pilih poster dari galeri), simpan file di local storage app
- **UI**: Material 3, tema gelap sebagai default (minimalis ala Letterboxd), grid poster pakai `GridView`
- **Package tambahan**: `uuid` (generate id), `intl` (format tanggal)

## 7. Tahapan Development

1. **Setup project** — struktur folder, model data, setup Isar
2. **CRUD dasar** — tambah/edit/hapus/lihat item per kategori, tanpa styling dulu
3. **UI 3 tab + navigasi** — bottom nav, grid poster, detail screen
4. **Status & rating flow** — logic ubah status, rating picker, progress episode
5. **Filter, sort, search**
6. **Stats screen**
7. **Polish UI** — animasi transisi, empty state, styling akhir
8. _(Opsional, Phase 2)_ — integrasi Jikan/TMDB API buat auto-fill

---

## 8. Prompt Siap Kirim ke Antigravity

Copy-paste blok di bawah ini langsung ke Antigravity:

```
Buatkan aplikasi Flutter untuk Android bernama "MWatchlist" — aplikasi tracker tontonan
pribadi mirip Letterboxd tapi versi minimalis, dengan 3 koleksi terpisah: Anime, Film,
dan Series (jangan digabung jadi satu list).

TECH STACK:
- Flutter, target Android
- State management: Riverpod
- Local database: Isar (offline-first, tanpa backend/server)
- Image picker: package image_picker untuk pilih poster dari galeri HP
- Tema: Material 3, dark mode sebagai default, desain minimalis dengan grid poster

MODEL DATA (WatchItem):
- id (String, uuid)
- type (enum: anime, movie, series)
- title (String)
- year (int, nullable)
- genres (List<String>)
- status (enum: planToWatch, watching, completed) — label tampilan: "Mau Ditonton",
  "Sedang Ditonton", "Sudah Ditonton"
- rating (double, nullable, skala 1-10, hanya bisa diisi kalau status = completed)
- posterPath (String, nullable — path file lokal)
- notes (String, nullable)
- progressCurrent (int, nullable — episode/season berjalan, khusus anime & series)
- progressTotal (int, nullable — total episode/season, khusus anime & series)
- dateAdded (DateTime)
- dateCompleted (DateTime, nullable)

NAVIGASI:
Bottom navigation dengan 4 tab: Anime, Film, Series, Stats.

LAYAR YANG DIBUTUHKAN:
1. List screen (satu untuk tiap kategori Anime/Film/Series):
   - Tampilan grid poster (2-3 kolom)
   - App bar dengan search icon dan filter/sort (filter by status, sort by rating/judul/
     tanggal ditambahkan)
   - Floating action button untuk tambah item baru
   - Empty state kalau koleksi masih kosong

2. Detail screen:
   - Poster besar di atas
   - Judul, tahun, genre, catatan
   - Progress episode/season (kalau kategori anime/series) dengan tombol tambah/kurang
   - Segmented button atau chip untuk ubah status (Mau/Sedang/Sudah)
   - Rating picker (muncul/aktif hanya kalau status = Sudah Ditonton)
   - Tombol edit dan hapus

3. Add/Edit screen (form):
   - Input judul, tahun, genre (pakai chip input, bisa tambah genre bebas)
   - Pilih status
   - Pilih poster dari galeri (image_picker)
   - Input progress episode/season (tampil hanya untuk anime/series)
   - Input catatan (opsional)

4. Stats screen:
   - Total item per kategori (anime/film/series)
   - Total yang sudah ditonton vs masih plan/watching
   - Rata-rata rating per kategori
   - List singkat item yang statusnya "Sedang Ditonton" saat ini

FITUR TAMBAHAN:
- Search dalam koleksi aktif (search by judul)
- Semua data tersimpan lokal pakai Isar, tidak perlu login/akun/internet
- Struktur folder rapi: pisahkan models/, providers/ (Riverpod), screens/, widgets/

Tolong bangun dari struktur project Flutter kosong, termasuk setup Isar schema,
Riverpod providers untuk CRUD tiap koleksi, dan semua screen di atas dengan
navigasi yang berfungsi penuh (bukan cuma UI statis).
```

---
**