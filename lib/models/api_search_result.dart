/// Model terpadu untuk hasil pencarian metadata online (Jikan & TMDB).
class ApiSearchResult {
  final String title;
  final int? year;
  final List<String> genres;
  final String? posterUrl;
  final int? totalEpisodes;
  final String? synopsis;

  const ApiSearchResult({
    required this.title,
    this.year,
    this.genres = const [],
    this.posterUrl,
    this.totalEpisodes,
    this.synopsis,
  });

  @override
  String toString() {
    return 'ApiSearchResult(title: $title, year: $year, genres: $genres, totalEpisodes: $totalEpisodes)';
  }
}
