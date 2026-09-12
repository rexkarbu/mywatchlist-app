import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_search_result.dart';

class TmdbApiService {
  /// Masukkan TMDB API Key v3 Anda di sini jika tidak di-pass lewat konstruktor.
  /// Dapatkan gratis di: https://www.themoviedb.org/settings/api
  static const String defaultApiKey = '';

  final String apiKey;
  final http.Client _client;

  TmdbApiService({String? apiKey, http.Client? client})
    : apiKey = apiKey ?? defaultApiKey,
      _client = client ?? http.Client();

  bool get hasApiKey =>
      apiKey.trim().isNotEmpty && apiKey != 'YOUR_TMDB_API_KEY';

  /// Mencari film dari TMDB API.
  Future<List<ApiSearchResult>> searchMovie(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];
    _checkApiKey();

    final uri = Uri.parse(
      'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=${Uri.encodeComponent(trimmed)}&language=id-ID&include_adult=false',
    );

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil data dari TMDB (Status: ${response.statusCode})',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['results'] as List<dynamic>? ?? [];

      return results.map((item) {
        final map = item as Map<String, dynamic>;
        final title =
            (map['title'] as String?) ??
            (map['original_title'] as String?) ??
            'Tanpa Judul';

        int? year;
        final releaseDate = map['release_date'] as String?;
        if (releaseDate != null && releaseDate.length >= 4) {
          year = int.tryParse(releaseDate.substring(0, 4));
        }

        final genreIds =
            (map['genre_ids'] as List<dynamic>?)?.cast<int>() ?? [];
        final genres = genreIds
            .map((id) => _genreMap[id] ?? 'Genre $id')
            .toList();

        final posterPath = map['poster_path'] as String?;
        final posterUrl = posterPath != null
            ? 'https://image.tmdb.org/t/p/w500$posterPath'
            : null;

        return ApiSearchResult(
          title: title,
          year: year,
          genres: genres,
          posterUrl: posterUrl,
          totalEpisodes: null, // Film tidak memiliki episode
          synopsis: (map['overview'] as String?)?.trim().isNotEmpty == true
              ? map['overview'] as String
              : null,
        );
      }).toList();
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal mencari Film dari TMDB: $e');
    }
  }

  /// Mencari series TV dari TMDB API.
  Future<List<ApiSearchResult>> searchSeries(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];
    _checkApiKey();

    final uri = Uri.parse(
      'https://api.themoviedb.org/3/search/tv?api_key=$apiKey&query=${Uri.encodeComponent(trimmed)}&language=id-ID&include_adult=false',
    );

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil data series dari TMDB (Status: ${response.statusCode})',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['results'] as List<dynamic>? ?? [];

      return results.map((item) {
        final map = item as Map<String, dynamic>;
        final title =
            (map['name'] as String?) ??
            (map['original_name'] as String?) ??
            'Tanpa Judul';

        int? year;
        final firstAirDate = map['first_air_date'] as String?;
        if (firstAirDate != null && firstAirDate.length >= 4) {
          year = int.tryParse(firstAirDate.substring(0, 4));
        }

        final genreIds =
            (map['genre_ids'] as List<dynamic>?)?.cast<int>() ?? [];
        final genres = genreIds
            .map((id) => _genreMap[id] ?? 'Genre $id')
            .toList();

        final posterPath = map['poster_path'] as String?;
        final posterUrl = posterPath != null
            ? 'https://image.tmdb.org/t/p/w500$posterPath'
            : null;

        return ApiSearchResult(
          title: title,
          year: year,
          genres: genres,
          posterUrl: posterUrl,
          totalEpisodes: null,
          synopsis: (map['overview'] as String?)?.trim().isNotEmpty == true
              ? map['overview'] as String
              : null,
        );
      }).toList();
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal mencari Series dari TMDB: $e');
    }
  }

  void _checkApiKey() {
    if (!hasApiKey) {
      throw Exception(
        'TMDB API Key belum diatur. Masukkan TMDB API Key v3 pada lib/services/tmdb_api_service.dart agar fitur pencarian Film & Series dapat digunakan.',
      );
    }
  }

  static const Map<int, String> _genreMap = {
    // Movie & TV Genres
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
    10759: 'Action & Adventure',
    10762: 'Kids',
    10763: 'News',
    10764: 'Reality',
    10765: 'Sci-Fi & Fantasy',
    10766: 'Soap',
    10767: 'Talk',
    10768: 'War & Politics',
  };
}
