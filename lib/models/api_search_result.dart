/// Model terpadu untuk hasil pencarian metadata online (AniList & TMDB).
class ApiSearchResult {
  final String title;
  final int? year;
  final List<String> genres;
  final String? posterUrl;
  final int? totalEpisodes;
  final String? synopsis;
  final String? format;

  const ApiSearchResult({
    required this.title,
    this.year,
    this.genres = const [],
    this.posterUrl,
    this.totalEpisodes,
    this.synopsis,
    this.format,
  });

  @override
  String toString() {
    return 'ApiSearchResult(title: $title, year: $year, genres: $genres, totalEpisodes: $totalEpisodes, format: $format)';
  }
}
