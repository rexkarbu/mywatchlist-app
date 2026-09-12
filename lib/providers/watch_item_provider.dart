import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/enums.dart';
import '../models/watch_item.dart';
import 'database_provider.dart';

/// Stream semua item per tipe — reaktif terhadap perubahan DB.
final watchItemsProvider = StreamProvider.family<List<WatchItem>, ItemType>((
  ref,
  type,
) {
  final repo = ref.watch(watchItemRepositoryProvider);
  return repo.watchByType(type);
});

// ---------------------------------------------------------------------------
// Filter & sort state — independen per ItemType, persisten saat pindah tab
// ---------------------------------------------------------------------------

/// Search query per tipe.
final searchQueryProvider = StateProvider.family<String, ItemType>(
  (ref, type) => '',
);

/// Filter status per tipe. null = tampilkan semua.
final statusFilterProvider = StateProvider.family<WatchStatus?, ItemType>(
  (ref, type) => null,
);

/// Sort option per tipe. Default: terbaru ditambahkan.
final sortOptionProvider = StateProvider.family<SortOption, ItemType>(
  (ref, type) => SortOption.dateAddedDesc,
);

/// Provider yang menggabungkan data + filter + sort.
/// Mengembalikan list yang sudah difilter dan diurutkan.
final filteredItemsProvider =
    Provider.family<AsyncValue<List<WatchItem>>, ItemType>((ref, type) {
      final itemsAsync = ref.watch(watchItemsProvider(type));
      final query = ref.watch(searchQueryProvider(type)).toLowerCase();
      final statusFilter = ref.watch(statusFilterProvider(type));
      final sortOption = ref.watch(sortOptionProvider(type));

      return itemsAsync.whenData((items) {
        var filtered = items.toList();

        // Filter by status.
        if (statusFilter != null) {
          filtered = filtered.where((i) => i.status == statusFilter).toList();
        }

        // Filter by search query.
        if (query.isNotEmpty) {
          filtered = filtered
              .where((i) => i.title.toLowerCase().contains(query))
              .toList();
        }

        // Sort.
        switch (sortOption) {
          case SortOption.dateAddedDesc:
            filtered.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
            break;
          case SortOption.titleAsc:
            filtered.sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
            );
            break;
          case SortOption.ratingDesc:
            filtered.sort((a, b) {
              // Rating null selalu terakhir.
              if (a.rating == null && b.rating == null) return 0;
              if (a.rating == null) return 1;
              if (b.rating == null) return -1;
              return b.rating!.compareTo(a.rating!);
            });
            break;
        }

        return filtered;
      });
    });
