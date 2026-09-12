import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/watch_item.dart';
import '../models/enums.dart';

const _uuid = Uuid();

/// Repository yang mengelola semua operasi database untuk WatchItem.
/// Diakses melalui Riverpod provider, bukan langsung dari UI.
class WatchItemRepository {
  final Isar _isar;

  WatchItemRepository(this._isar);

  // ---------------------------------------------------------------------------
  // Query
  // ---------------------------------------------------------------------------

  /// Stream semua item berdasarkan tipe, reaktif terhadap perubahan DB.
  Stream<List<WatchItem>> watchByType(ItemType type) {
    return _isar.watchItems
        .filter()
        .typeEqualTo(type)
        .sortByDateAddedDesc()
        .watch(fireImmediately: true);
  }

  /// Ambil satu item berdasarkan Isar id.
  Future<WatchItem?> getById(int id) {
    return _isar.watchItems.get(id);
  }

  // ---------------------------------------------------------------------------
  // Create
  // ---------------------------------------------------------------------------

  /// Tambah item baru. UUID di-generate sekali di sini.
  /// Mengembalikan id Isar dari item yang baru dibuat.
  Future<int> addItem({
    required ItemType type,
    required String title,
    int? year,
    List<String> genres = const [],
    WatchStatus status = WatchStatus.planToWatch,
    double? rating,
    String? posterPath,
    String? notes,
    int? progressCurrent,
    int? progressTotal,
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw ArgumentError('Judul tidak boleh kosong.');
    }

    // Validasi genre: trim, non-empty, deduplicate (case-insensitive).
    final cleanGenres = _cleanGenres(genres);

    // Validasi progress.
    _validateProgress(type, progressCurrent, progressTotal);

    // Rating hanya boleh saat completed.
    final validatedRating = _validateRating(status, rating);

    final item = WatchItem()
      ..uuid = _uuid.v4()
      ..type = type
      ..title = trimmedTitle
      ..year = year
      ..genres = cleanGenres
      ..status = status
      ..rating = validatedRating
      ..posterPath = posterPath
      ..notes = notes
      ..progressCurrent = type.hasProgress ? (progressCurrent ?? 0) : null
      ..progressTotal = type.hasProgress ? progressTotal : null
      ..dateAdded = DateTime.now()
      ..dateCompleted = status == WatchStatus.completed ? DateTime.now() : null;

    return _isar.writeTxn(() => _isar.watchItems.put(item));
  }

  // ---------------------------------------------------------------------------
  // Update
  // ---------------------------------------------------------------------------

  /// Update item yang ada. dateAdded tidak berubah, uuid dipertahankan.
  Future<void> updateItem(
    WatchItem item, {
    String? title,
    int? year,
    List<String>? genres,
    WatchStatus? status,
    double? rating,
    String? posterPath,
    String? notes,
    int? progressCurrent,
    int? progressTotal,
    bool clearRating = false,
    bool clearPoster = false,
  }) async {
    if (title != null) {
      final trimmed = title.trim();
      if (trimmed.isEmpty) {
        throw ArgumentError('Judul tidak boleh kosong.');
      }
      item.title = trimmed;
    }

    if (genres != null) {
      item.genres = _cleanGenres(genres);
    }

    if (year != null) item.year = year;
    if (notes != null) item.notes = notes;

    // Status change logic.
    final newStatus = status ?? item.status;
    final oldStatus = item.status;

    if (newStatus != oldStatus) {
      item.status = newStatus;

      if (newStatus == WatchStatus.completed) {
        item.dateCompleted = DateTime.now();
        // Jika total diketahui, samakan current dengan total.
        if (item.type.hasProgress && item.progressTotal != null) {
          item.progressCurrent = item.progressTotal;
        }
      } else {
        // Keluar dari completed: kosongkan dateCompleted dan rating.
        if (oldStatus == WatchStatus.completed) {
          item.dateCompleted = null;
          item.rating = null;
        }
      }
    }

    // Rating: hanya bisa diisi saat completed.
    if (clearRating) {
      item.rating = null;
    } else if (rating != null) {
      item.rating = _validateRating(item.status, rating);
    }

    // Progress.
    if (item.type.hasProgress) {
      if (progressTotal != null) {
        item.progressTotal = progressTotal > 0 ? progressTotal : null;
      }
      if (progressCurrent != null) {
        _validateProgress(item.type, progressCurrent, item.progressTotal);
        item.progressCurrent = progressCurrent;
      }
    }

    // Poster.
    if (clearPoster) {
      await _deletePosterFile(item.posterPath);
      item.posterPath = null;
    } else if (posterPath != null) {
      // Hapus poster lama kalau diganti.
      if (item.posterPath != null && item.posterPath != posterPath) {
        await _deletePosterFile(item.posterPath);
      }
      item.posterPath = posterPath;
    }

    await _isar.writeTxn(() => _isar.watchItems.put(item));
  }

  /// Tambah progress +1 episode. Mengembalikan item yang sudah diperbarui.
  Future<WatchItem?> incrementProgress(WatchItem item) async {
    if (!item.type.hasProgress) return item;

    final current = item.progressCurrent ?? 0;
    final total = item.progressTotal;

    // Tidak boleh melampaui total.
    if (total != null && current >= total) return item;

    final newCurrent = current + 1;
    item.progressCurrent = newCurrent;

    // Menaikkan progress dari planToWatch → watching.
    if (item.status == WatchStatus.planToWatch) {
      item.status = WatchStatus.watching;
    }

    // Mencapai total TIDAK otomatis mengubah status ke completed.

    await _isar.writeTxn(() => _isar.watchItems.put(item));
    return item;
  }

  /// Kurangi progress -1 episode.
  Future<WatchItem?> decrementProgress(WatchItem item) async {
    if (!item.type.hasProgress) return item;

    final current = item.progressCurrent ?? 0;
    if (current <= 0) return item;

    item.progressCurrent = current - 1;

    await _isar.writeTxn(() => _isar.watchItems.put(item));
    return item;
  }

  // ---------------------------------------------------------------------------
  // Delete
  // ---------------------------------------------------------------------------

  /// Hapus item dan file poster-nya.
  Future<bool> deleteItem(int id) async {
    final item = await _isar.watchItems.get(id);
    if (item != null) {
      await _deletePosterFile(item.posterPath);
    }
    return _isar.writeTxn(() => _isar.watchItems.delete(id));
  }

  // ---------------------------------------------------------------------------
  // Statistics
  // ---------------------------------------------------------------------------

  /// Hitung total item per tipe.
  Future<int> countByType(ItemType type) {
    return _isar.watchItems.filter().typeEqualTo(type).count();
  }

  /// Hitung item per tipe dan status.
  Future<int> countByTypeAndStatus(ItemType type, WatchStatus status) {
    return _isar.watchItems
        .filter()
        .typeEqualTo(type)
        .statusEqualTo(status)
        .count();
  }

  /// Rata-rata rating per tipe. Hanya item completed dengan rating non-null.
  Future<double?> averageRatingByType(ItemType type) async {
    final items = await _isar.watchItems
        .filter()
        .typeEqualTo(type)
        .statusEqualTo(WatchStatus.completed)
        .ratingIsNotNull()
        .findAll();

    if (items.isEmpty) return null;

    final sum = items.fold<double>(0.0, (acc, item) => acc + item.rating!);
    return sum / items.length;
  }

  /// Ambil semua item dengan status "Sedang Ditonton".
  Future<List<WatchItem>> getCurrentlyWatching() {
    return _isar.watchItems
        .filter()
        .statusEqualTo(WatchStatus.watching)
        .sortByDateAddedDesc()
        .findAll();
  }

  // ---------------------------------------------------------------------------
  // Image helpers
  // ---------------------------------------------------------------------------

  /// Salin gambar ke direktori permanen aplikasi.
  /// Mengembalikan path baru.
  Future<String> copyPosterToAppDir(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final postersDir = Directory('${appDir.path}/posters');
    if (!await postersDir.exists()) {
      await postersDir.create(recursive: true);
    }

    final ext = sourcePath.split('.').last;
    final fileName = '${_uuid.v4()}.$ext';
    final destPath = '${postersDir.path}/$fileName';

    await File(sourcePath).copy(destPath);
    return destPath;
  }

  /// Unduh poster dari URL internet dan simpan ke direktori lokal aplikasi (posters/).
  /// Mengembalikan path file lokal baru.
  Future<String> downloadPosterToAppDir(
    String url, {
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    final response = await httpClient
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengunduh gambar poster (Status: ${response.statusCode})',
      );
    }

    final appDir = await getApplicationDocumentsDirectory();
    final postersDir = Directory('${appDir.path}/posters');
    if (!await postersDir.exists()) {
      await postersDir.create(recursive: true);
    }

    String ext = 'jpg';
    final uriPath = Uri.parse(url).path;
    if (uriPath.contains('.')) {
      final rawExt = uriPath.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'webp'].contains(rawExt)) {
        ext = rawExt;
      }
    }

    final fileName = '${_uuid.v4()}.$ext';
    final destFile = File('${postersDir.path}/$fileName');
    await destFile.writeAsBytes(response.bodyBytes);
    return destFile.path;
  }

  // ---------------------------------------------------------------------------
  // Backup & Restore (JSON)
  // ---------------------------------------------------------------------------

  /// Ekspor seluruh data WatchItem ke format JSON string.
  Future<String> exportDatabaseToJson() async {
    final items = await _isar.watchItems.where().findAll();
    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Impor data WatchItem dari JSON string.
  /// Bersifat idempotent: jika uuid sudah ada di database, item ditimpa (update),
  /// sehingga total data tidak duplikat.
  /// Mengembalikan jumlah item yang berhasil diproses/diimpor.
  Future<int> importDatabaseFromJson(String jsonString) async {
    final dynamic decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Format file backup JSON tidak valid.');
    }

    final itemsRaw = decoded['items'];
    if (itemsRaw is! List<dynamic>) {
      throw const FormatException(
        'Data items dalam file backup tidak ditemukan.',
      );
    }

    int count = 0;
    await _isar.writeTxn(() async {
      for (final raw in itemsRaw) {
        if (raw is! Map<String, dynamic>) continue;
        final itemFromJson = WatchItem.fromJson(raw);

        // Cek apakah item dengan UUID ini sudah ada di database.
        final existing = await _isar.watchItems
            .filter()
            .uuidEqualTo(itemFromJson.uuid)
            .findFirst();

        if (existing != null) {
          // Pertahankan Isar ID dan poster lokal yang sudah ada.
          itemFromJson.id = existing.id;
          if (existing.posterPath != null && itemFromJson.posterPath == null) {
            itemFromJson.posterPath = existing.posterPath;
          }
        }

        await _isar.watchItems.put(itemFromJson);
        count++;
      }
    });

    return count;
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  List<String> _cleanGenres(List<String> genres) {
    final seen = <String>{};
    final result = <String>[];
    for (final g in genres) {
      final trimmed = g.trim();
      if (trimmed.isNotEmpty && seen.add(trimmed.toLowerCase())) {
        result.add(trimmed);
      }
    }
    return result;
  }

  void _validateProgress(ItemType type, int? current, int? total) {
    if (!type.hasProgress) return;

    if (total != null && total <= 0) {
      throw ArgumentError('Total episode harus lebih dari 0.');
    }
    if (current != null) {
      if (current < 0) {
        throw ArgumentError('Progress tidak boleh negatif.');
      }
      if (total != null && current > total) {
        throw ArgumentError(
          'Progress ($current) tidak boleh melampaui total ($total).',
        );
      }
    }
  }

  double? _validateRating(WatchStatus status, double? rating) {
    if (rating == null) return null;
    if (status != WatchStatus.completed) return null;
    if (rating < 1.0 || rating > 10.0) {
      throw ArgumentError('Rating harus antara 1.0 dan 10.0.');
    }
    // Bulatkan ke 0.5 terdekat.
    return (rating * 2).roundToDouble() / 2;
  }

  Future<void> _deletePosterFile(String? path) async {
    if (path == null) return;
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // File mungkin sudah tidak ada, abaikan.
    }
  }
}

/// Buka Isar database. Dipanggil sekali melalui provider.
Future<Isar> openIsarDatabase() async {
  if (Isar.instanceNames.isNotEmpty) {
    return Future.value(Isar.getInstance());
  }

  final dir = await getApplicationDocumentsDirectory();
  return Isar.open([WatchItemSchema], directory: dir.path, name: 'mywatchlist');
}
