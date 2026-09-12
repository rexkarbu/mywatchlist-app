/// Tipe koleksi tontonan dan bacaan.
enum ItemType {
  anime,
  movie,
  series,
  reading;

  String get label {
    switch (this) {
      case ItemType.anime:
        return 'Anime';
      case ItemType.movie:
        return 'Film';
      case ItemType.series:
        return 'Series';
      case ItemType.reading:
        return 'Reading';
    }
  }

  /// Apakah tipe ini memiliki progress (episode/chapter).
  bool get hasProgress => this != ItemType.movie;

  /// Satuan unit progress.
  String get progressUnit => this == ItemType.reading ? 'Chapter' : 'Episode';
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
