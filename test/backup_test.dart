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
      name: 'backup_test_${DateTime.now().millisecondsSinceEpoch}',
    );
    repo = WatchItemRepository(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  group('Serialisasi WatchItem JSON', () {
    test(
      'roundtrip toJson -> fromJson menghasilkan objek dengan data identik',
      () {
        final now = DateTime.now();
        final original = WatchItem()
          ..uuid = 'test-uuid-12345'
          ..type = ItemType.anime
          ..title = 'Sousou no Frieren'
          ..year = 2023
          ..genres = ['Adventure', 'Drama', 'Fantasy']
          ..status = WatchStatus.completed
          ..rating = 9.5
          ..notes = 'Anime terbaik tahun ini!'
          ..progressCurrent = 28
          ..progressTotal = 28
          ..dateAdded = now
          ..dateCompleted = now;

        final jsonMap = original.toJson();
        final restored = WatchItem.fromJson(jsonMap);

        expect(restored.uuid, original.uuid);
        expect(restored.type, original.type);
        expect(restored.title, original.title);
        expect(restored.year, original.year);
        expect(restored.genres, original.genres);
        expect(restored.status, original.status);
        expect(restored.rating, original.rating);
        expect(restored.notes, original.notes);
        expect(restored.progressCurrent, original.progressCurrent);
        expect(restored.progressTotal, original.progressTotal);
        expect(
          restored.dateAdded.toIso8601String(),
          original.dateAdded.toIso8601String(),
        );
        expect(
          restored.dateCompleted?.toIso8601String(),
          original.dateCompleted?.toIso8601String(),
        );
      },
    );
  });

  group('Database Export & Import (Idempotent)', () {
    test(
      'ekspor menghasilkan JSON dengan struktur version, exportedAt, dan items',
      () async {
        await repo.addItem(
          type: ItemType.movie,
          title: 'Interstellar',
          year: 2014,
          genres: ['Sci-Fi', 'Adventure'],
        );

        final jsonString = await repo.exportDatabaseToJson();
        expect(jsonString, contains('"version": 1'));
        expect(jsonString, contains('"exportedAt":'));
        expect(jsonString, contains('"items":'));
        expect(jsonString, contains('Interstellar'));
      },
    );

    test('impor dengan UUID yang sama menimpa data dan TIDAK menambah jumlah record', () async {
      final id = await repo.addItem(
        type: ItemType.series,
        title: 'Breaking Bad',
        year: 2008,
        genres: ['Crime', 'Drama'],
      );

      final initialItem = await repo.getById(id);
      expect(initialItem, isNotNull);

      // Ekspor data awal
      final exportedJson = await repo.exportDatabaseToJson();

      // Total count awal harus 1
      final countBefore = await isar.watchItems.count();
      expect(countBefore, 1);

      // Impor kembali file backup yang sama persis
      final importedCount = await repo.importDatabaseFromJson(exportedJson);
      expect(importedCount, 1);

      // Total count di database tetap 1 (tidak duplikat)
      final countAfter = await isar.watchItems.count();
      expect(countAfter, 1);

      // Item di database memiliki UUID dan judul yang sama
      final itemAfter = await isar.watchItems
          .filter()
          .uuidEqualTo(initialItem!.uuid)
          .findFirst();
      expect(itemAfter, isNotNull);
      expect(itemAfter!.title, 'Breaking Bad');
    });

    test(
      'impor beberapa item baru meningkatkan jumlah data secara benar',
      () async {
        const jsonBackup = '''
      {
        "version": 1,
        "exportedAt": "2026-09-12T12:00:00.000Z",
        "items": [
          {
            "uuid": "uuid-item-1",
            "type": "anime",
            "title": "Steins;Gate",
            "year": 2011,
            "genres": ["Sci-Fi", "Thriller"],
            "status": "completed",
            "rating": 10.0,
            "notes": "El Psy Kongroo",
            "progressCurrent": 24,
            "progressTotal": 24,
            "dateAdded": "2026-09-01T00:00:00.000Z",
            "dateCompleted": "2026-09-05T00:00:00.000Z"
          },
          {
            "uuid": "uuid-item-2",
            "type": "movie",
            "title": "Oppenheimer",
            "year": 2023,
            "genres": ["Biography", "Drama", "History"],
            "status": "planToWatch",
            "rating": null,
            "notes": null,
            "progressCurrent": null,
            "progressTotal": null,
            "dateAdded": "2026-09-02T00:00:00.000Z",
            "dateCompleted": null
          }
        ]
      }
      ''';

        final importedCount = await repo.importDatabaseFromJson(jsonBackup);
        expect(importedCount, 2);

        final totalInDb = await isar.watchItems.count();
        expect(totalInDb, 2);

        // Mengimpor ulang tidak menggandakan data
        final reimportedCount = await repo.importDatabaseFromJson(jsonBackup);
        expect(reimportedCount, 2);
        expect(await isar.watchItems.count(), 2);
      },
    );
  });
}
