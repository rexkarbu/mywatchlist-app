import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_search_result.dart';

class AniListApiService {
  static const String _endpoint = 'https://graphql.anilist.co';

  final http.Client _client;

  AniListApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mencari anime berdasarkan query dari AniList GraphQL API.
  Future<List<ApiSearchResult>> searchAnime(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    const queryGql = '''
query (\$search: String) {
  Page(page: 1, perPage: 10) {
    media(search: \$search, type: ANIME, sort: SEARCH_MATCH) {
      id
      title {
        romaji
        english
        native
      }
      startDate {
        year
      }
      genres
      episodes
      format
      coverImage {
        large
      }
      description
    }
  }
}
''';

    return _postQuery(
      queryGql: queryGql,
      variables: {'search': trimmed},
      isAnime: true,
    );
  }

  /// Mencari reading (Manga, Manhwa, Manhua, Light Novel) dari AniList GraphQL API.
  Future<List<ApiSearchResult>> searchReading(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    const queryGql = '''
query (\$search: String) {
  Page(page: 1, perPage: 10) {
    media(search: \$search, type: MANGA, sort: SEARCH_MATCH) {
      id
      title {
        romaji
        english
        native
      }
      startDate {
        year
      }
      genres
      chapters
      volumes
      format
      coverImage {
        large
      }
      description
    }
  }
}
''';

    return _postQuery(
      queryGql: queryGql,
      variables: {'search': trimmed},
      isAnime: false,
    );
  }

  Future<List<ApiSearchResult>> _postQuery({
    required String queryGql,
    required Map<String, dynamic> variables,
    required bool isAnime,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(_endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'query': queryGql,
              'variables': variables,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil data dari AniList (Status: ${response.statusCode})',
        );
      }

      final json = jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;
      final data = json['data'] as Map<String, dynamic>?;
      final page = data?['Page'] as Map<String, dynamic>?;
      final mediaList = page?['media'] as List<dynamic>? ?? [];

      return mediaList.map((item) {
        final map = item as Map<String, dynamic>;

        // Title: prioritaskan english jika ada, fallback ke romaji, lalu native
        final titleMap = map['title'] as Map<String, dynamic>?;
        final english = titleMap?['english'] as String?;
        final romaji = titleMap?['romaji'] as String?;
        final native = titleMap?['native'] as String?;

        final title = (english != null && english.trim().isNotEmpty)
            ? english.trim()
            : (romaji != null && romaji.trim().isNotEmpty)
                ? romaji.trim()
                : (native != null && native.trim().isNotEmpty)
                    ? native.trim()
                    : 'Tanpa Judul';

        // Tahun rilis
        final startDate = map['startDate'] as Map<String, dynamic>?;
        final year = startDate?['year'] as int?;

        // List genre
        final genresList = <String>[];
        if (map['genres'] is List) {
          for (final g in map['genres']) {
            if (g != null && g.toString().trim().isNotEmpty) {
              genresList.add(g.toString().trim());
            }
          }
        }

        // Poster image
        final coverImage = map['coverImage'] as Map<String, dynamic>?;
        final posterUrl = coverImage?['large'] as String?;

        // Total progress count (episodes untuk anime, chapters ?? volumes untuk reading)
        int? totalProgress;
        if (isAnime) {
          totalProgress = map['episodes'] as int?;
        } else {
          totalProgress = (map['chapters'] as int?) ?? (map['volumes'] as int?);
        }

        // Format (MANGA, NOVEL, TV, MOVIE, dll.)
        final format = map['format'] as String?;

        // Sinopsis dibersihkan dari HTML tags
        final rawDesc = map['description'] as String?;
        final synopsis = _cleanHtmlDescription(rawDesc);

        return ApiSearchResult(
          title: title,
          year: year,
          genres: genresList,
          posterUrl: posterUrl,
          totalEpisodes: totalProgress,
          synopsis: synopsis,
          format: format,
        );
      }).toList();
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Gagal melakukan pencarian AniList: $e');
    }
  }

  /// Membersihkan tag HTML seperti <br>, <i>, <b> dari deskripsi sinopsis AniList.
  static String? _cleanHtmlDescription(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    return raw
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }
}
