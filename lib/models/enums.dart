/// Tipe koleksi tontonan.
enum ItemType {
  anime,
  movie,
  series;

  String get label {
    switch (this) {
      case ItemType.anime:
        return 'Anime';
      case ItemType.movie:
        return 'Film';
      case ItemType.series:
        return 'Series';
    }
  }

  /// Apakah tipe ini memiliki progress episode.
  bool get hasProgress => this != ItemType.movie;
}

/// Status tontonan.
enum WatchStatus {
  planToWatch,
  watching,
  completed;

  String get label {
    switch (this) {
      case WatchStatus.planToWatch:
        return 'Mau Ditonton';
      case WatchStatus.watching:
        return 'Sedang Ditonton';
      case WatchStatus.completed:
        return 'Sudah Ditonton';
    }
  }
}

/// Opsi pengurutan daftar.
enum SortOption {
  dateAddedDesc,
  titleAsc,
  ratingDesc;

  String get label {
    switch (this) {
      case SortOption.dateAddedDesc:
        return 'Terbaru Ditambahkan';
      case SortOption.titleAsc:
        return 'Judul A–Z';
      case SortOption.ratingDesc:
        return 'Rating Tertinggi';
    }
  }
}
