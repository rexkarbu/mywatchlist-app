import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums.dart';
import '../models/watch_item.dart';
import '../services/database_service.dart';
import 'database_provider.dart';

/// Data statistik untuk satu kategori.
class CategoryStats {
  final ItemType type;
  final int total;
  final int planToWatch;
  final int watching;
  final int completed;
  final double? averageRating; // null jika belum ada item rated

  const CategoryStats({
    required this.type,
    required this.total,
    required this.planToWatch,
    required this.watching,
    required this.completed,
    this.averageRating,
  });
}

/// Data statistik lengkap untuk Stats screen.
class AllStats {
  final CategoryStats anime;
  final CategoryStats movie;
  final CategoryStats series;
  final List<WatchItem> currentlyWatching;

  const AllStats({
    required this.anime,
    required this.movie,
    required this.series,
    required this.currentlyWatching,
  });

  int get totalAll => anime.total + movie.total + series.total;
  int get totalCompleted =>
      anime.completed + movie.completed + series.completed;
  int get totalWatching => anime.watching + movie.watching + series.watching;
  int get totalPlanToWatch =>
      anime.planToWatch + movie.planToWatch + series.planToWatch;
}

/// Provider untuk statistik lengkap. FutureProvider agar bisa loading/error.
final statsProvider = FutureProvider<AllStats>((ref) async {
  final repo = ref.watch(watchItemRepositoryProvider);

  // Fetch semua data secara paralel.
  final results = await Future.wait([
    _fetchCategoryStats(repo, ItemType.anime),
    _fetchCategoryStats(repo, ItemType.movie),
    _fetchCategoryStats(repo, ItemType.series),
    repo.getCurrentlyWatching(),
  ]);

  return AllStats(
    anime: results[0] as CategoryStats,
    movie: results[1] as CategoryStats,
    series: results[2] as CategoryStats,
    currentlyWatching: results[3] as List<WatchItem>,
  );
});

Future<CategoryStats> _fetchCategoryStats(
  WatchItemRepository repo,
  ItemType type,
) async {
  final results = await Future.wait([
    repo.countByType(type),
    repo.countByTypeAndStatus(type, WatchStatus.planToWatch),
    repo.countByTypeAndStatus(type, WatchStatus.watching),
    repo.countByTypeAndStatus(type, WatchStatus.completed),
    repo.averageRatingByType(type),
  ]);

  return CategoryStats(
    type: type,
    total: results[0] as int,
    planToWatch: results[1] as int,
    watching: results[2] as int,
    completed: results[3] as int,
    averageRating: results[4] as double?,
  );
}
