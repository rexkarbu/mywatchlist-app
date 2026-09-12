import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_search_result.dart';

class JikanApiService {
  final http.Client _client;

  JikanApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mencari anime berdasarkan query dari Jikan v4 API.
  Future<List<ApiSearchResult>> searchAnime(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final uri = Uri.parse(
      'https://api.jikan.moe/v4/anime?q=${Uri.encodeComponent(trimmed)}&limit=10',
    );

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil data dari Jikan API (Status: ${response.statusCode})',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['data'] as List<dynamic>? ?? [];

      return data.map((item) {
        final map = item as Map<String, dynamic>;

        // Tahun rilis: utamakan 'year', fallback ke aired.prop.from.year
        int? year = map['year'] as int?;
        if (year == null && map['aired'] != null) {
          final prop = map['aired']['prop'];
          if (prop != null && prop['from'] != null) {
            year = prop['from']['year'] as int?;
          }
        }

        // List genre
        final genresList = <String>[];
        if (map['genres'] is List) {
          for (final g in map['genres']) {
            if (g is Map && g['name'] != null) {
              genresList.add(g['name'].toString());
            }
          }
        }
        if (map['themes'] is List) {
          for (final t in map['themes']) {
            if (t is Map && t['name'] != null) {
              genresList.add(t['name'].toString());
            }
          }
        }

        // Poster image
        String? posterUrl;
        if (map['images'] != null && map['images']['jpg'] != null) {
          final jpg = map['images']['jpg'] as Map<String, dynamic>;
          posterUrl = (jpg['large_image_url'] ?? jpg['image_url']) as String?;
        }

        final title = (map['title_english'] as String?)?.isNotEmpty == true
            ? map['title_english'] as String
            : (map['title'] as String? ?? 'Tanpa Judul');

        return ApiSearchResult(
          title: title,
          year: year,
          genres: genresList,
          posterUrl: posterUrl,
          totalEpisodes: map['episodes'] as int?,
          synopsis: map['synopsis'] as String?,
        );
      }).toList();
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal melakukan pencarian Anime: $e');
    }
  }
}
