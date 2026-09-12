import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import 'package:my_watchlist/models/enums.dart';
import 'package:my_watchlist/models/watch_item.dart';
import 'package:my_watchlist/services/database_service.dart';

void main() {
  late Isar isar;
  late WatchItemRepository repo;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  setUp(() async {
    isar = await Isar.open(
      [WatchItemSchema],
      directory: '',
      name: 'test_${DateTime.now().millisecondsSinceEpoch}',
    );
    repo = WatchItemRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('Aturan Judul', () {
    test('judul yang di-trim kosong harus ditolak', () {
      expect(
        () => repo.addItem(type: ItemType.anime, title: '   '),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('judul harus di-trim saat disimpan', () async {
      final id = await repo.addItem(
        type: ItemType.movie,
        title: '  Inception  ',
      );
      final item = await repo.getById(id);
      expect(item!.title, 'Inception');
    });
  });

  group('Aturan Genre', () {
    test('genre dideduplikasi tanpa membedakan kapitalisasi', () async {
      final id = await repo.addItem(
        type: ItemType.anime,
        title: 'Test',
        genres: ['Action', 'action', 'DRAMA', 'drama', 'Action'],
      );
      final item = await repo.getById(id);
      expect(item!.genres, ['Action', 'DRAMA']);
    });

    test('genre kosong dan spasi-saja dibuang', () async {
      final id = await repo.addItem(
        type: ItemType.anime,
        title: 'Test',
        genres: ['', '  ', 'Valid', ' '],
      );
      final item = await repo.getById(id);
      expect(item!.genres, ['Valid']);
    });
  });

  group('Aturan Progress', () {
    test('film tidak memiliki progress', () async {
      final id = await repo.addItem(
        type: ItemType.movie,
        title: 'Film Test',
        progressCurrent: 5,
        progressTotal: 10,
      );
      final item = await repo.getById(id);
      expect(item!.progressCurrent, isNull);
      expect(item.progressTotal, isNull);
    });

    test('anime/series: progressCurrent default 0', () async {
      final id = await repo.addItem(type: ItemType.anime, title: 'Anime Test');
      final item = await repo.getById(id);
      expect(item!.progressCurrent, 0);
    });

    test('progressTotal boleh null', () async {
      final id = await repo.addItem(
        type: ItemType.series,
        title: 'Series Test',
      );
      final item = await repo.getById(id);
      expect(item!.progressTotal, isNull);
    });

    test('total harus positif jika diketahui', () {
      expect(
        () =>
            repo.addItem(type: ItemType.anime, title: 'Test', progressTotal: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('current tidak boleh melampaui total', () {
      expect(
        () => repo.addItem(
          type: ItemType.anime,
          title: 'Test',
          progressCurrent: 15,
          progressTotal: 12,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('tombol +1 tidak melampaui total', () async {
      final id = await repo.addItem(
        type: ItemType.anime,
        title: 'Test',
        progressCurrent: 12,
        progressTotal: 12,
      );
      var item = await repo.getById(id);
      item = await repo.incrementProgress(item!);
      expect(item!.progressCurrent, 12); // Tetap 12, tidak bertambah.
    });

    test(
      'menaikkan progress dari planToWatch mengubah status ke watching',
      () async {
        final id = await repo.addItem(
          type: ItemType.anime,
          title: 'Test',
          status: WatchStatus.planToWatch,
        );
        var item = await repo.getById(id);
        item = await repo.incrementProgress(item!);
        expect(item!.status, WatchStatus.watching);
        expect(item.progressCurrent, 1);
      },
    );

    test(
      'mencapai total TIDAK otomatis mengubah status ke completed',
      () async {
        final id = await repo.addItem(
          type: ItemType.anime,
          title: 'Test',
          status: WatchStatus.watching,
          progressCurrent: 11,
          progressTotal: 12,
        );
        var item = await repo.getById(id);
        item = await repo.incrementProgress(item!);
        expect(item!.progressCurrent, 12);
        expect(item.status, WatchStatus.watching); // Tetap watching.
      },
    );
  });

  group('Aturan Status & Rating', () {
    test('rating hanya bisa diisi saat completed', () async {
      final id = await repo.addItem(
        type: ItemType.movie,
        title: 'Test',
        status: WatchStatus.watching,
        rating: 8.0,
      );
      final item = await repo.getById(id);
      expect(item!.rating, isNull); // Rating diabaikan karena bukan completed.
    });

    test('rating valid: 1-10 dengan langkah 0.5', () async {
      final id = await repo.addItem(
        type: ItemType.movie,
        title: 'Test',
        status: WatchStatus.completed,
        rating: 7.3, // Dibulatkan ke 7.5.
      );
      final item = await repo.getById(id);
      expect(item!.rating, 7.5);
    });

    test(
      'saat menjadi completed: dateCompleted terisi, current = total',
      () async {
        final id = await repo.addItem(
          type: ItemType.anime,
          title: 'Test',
          status: WatchStatus.watching,
          progressCurrent: 5,
          progressTotal: 12,
        );
        var item = await repo.getById(id);
        await repo.updateItem(item!, status: WatchStatus.completed);
        item = await repo.getById(id);
        expect(item!.dateCompleted, isNotNull);
        expect(item.progressCurrent, 12); // Disamakan dengan total.
      },
    );

    test('saat keluar dari completed: hapus dateCompleted dan rating, pertahankan progress', () async {
      final id = await repo.addItem(
        type: ItemType.anime,
        title: 'Test',
        status: WatchStatus.completed,
        rating: 9.0,
        progressCurrent: 12,
        progressTotal: 12,
      );
      var item = await repo.getById(id);
      expect(item!.dateCompleted, isNotNull);
      expect(item.rating, 9.0);

      await repo.updateItem(item, status: WatchStatus.watching);
      item = await repo.getById(id);
      expect(item!.dateCompleted, isNull);
      expect(item.rating, isNull);
      expect(item.progressCurrent, 12); // Pertahankan progress.
    });

    test('rating bisa dikosongkan kembali', () async {
      final id = await repo.addItem(
        type: ItemType.movie,
        title: 'Test',
        status: WatchStatus.completed,
        rating: 8.0,
      );
      var item = await repo.getById(id);
      expect(item!.rating, 8.0);

      await repo.updateItem(item, clearRating: true);
      item = await repo.getById(id);
      expect(item!.rating, isNull);
    });

    test('dateAdded tidak berubah saat edit', () async {
      final id = await repo.addItem(type: ItemType.movie, title: 'Original');
      var item = await repo.getById(id);
      final originalDate = item!.dateAdded;

      await Future.delayed(const Duration(milliseconds: 10));
      await repo.updateItem(item, title: 'Updated');
      item = await repo.getById(id);
      expect(item!.dateAdded, originalDate); // Tidak berubah.
      expect(item.title, 'Updated');
    });
  });

  group('Statistik', () {
    test(
      'rata-rata rating hanya menghitung completed dengan rating non-null',
      () async {
        // 3 item completed, hanya 2 punya rating.
        await repo.addItem(
          type: ItemType.anime,
          title: 'A',
          status: WatchStatus.completed,
          rating: 8.0,
        );
        await repo.addItem(
          type: ItemType.anime,
          title: 'B',
          status: WatchStatus.completed,
          rating: 6.0,
        );
        await repo.addItem(
          type: ItemType.anime,
          title: 'C',
          status: WatchStatus.completed,
          // rating null
        );

        final avg = await repo.averageRatingByType(ItemType.anime);
        expect(avg, 7.0); // (8 + 6) / 2 = 7.0
      },
    );

    test('rata-rata null jika belum ada item rated', () async {
      final avg = await repo.averageRatingByType(ItemType.movie);
      expect(avg, isNull);
    });

    test('count per tipe dan status benar', () async {
      await repo.addItem(
        type: ItemType.anime,
        title: 'A1',
        status: WatchStatus.planToWatch,
      );
      await repo.addItem(
        type: ItemType.anime,
        title: 'A2',
        status: WatchStatus.watching,
      );
      await repo.addItem(
        type: ItemType.anime,
        title: 'A3',
        status: WatchStatus.completed,
      );
      await repo.addItem(
        type: ItemType.movie,
        title: 'M1',
        status: WatchStatus.completed,
      );

      expect(await repo.countByType(ItemType.anime), 3);
      expect(await repo.countByType(ItemType.movie), 1);
      expect(
        await repo.countByTypeAndStatus(ItemType.anime, WatchStatus.watching),
        1,
      );
    });
  });

  group('UUID', () {
    test(
      'UUID dibuat sekali saat tambah dan dipertahankan saat edit',
      () async {
        final id = await repo.addItem(type: ItemType.anime, title: 'Test');
        var item = await repo.getById(id);
        final originalUuid = item!.uuid;
        expect(originalUuid, isNotEmpty);

        await repo.updateItem(item, title: 'Updated');
        item = await repo.getById(id);
        expect(item!.uuid, originalUuid); // UUID tidak berubah.
      },
    );
  });
}
