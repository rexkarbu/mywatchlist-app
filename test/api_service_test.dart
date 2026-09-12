import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:my_watchlist/models/api_search_result.dart';
import 'package:my_watchlist/services/anilist_api_service.dart';
import 'package:my_watchlist/services/tmdb_api_service.dart';

void main() {
  group('ApiSearchResult Model', () {
    test('properti terisi dengan benar termasuk format', () {
      const result = ApiSearchResult(
        title: 'Frieren: Beyond Journey\'s End',
        year: 2023,
        genres: ['Adventure', 'Drama', 'Fantasy'],
        posterUrl: 'https://example.com/poster.jpg',
        totalEpisodes: 28,
        synopsis: 'Petualangan Frieren...',
        format: 'TV',
      );

      expect(result.title, 'Frieren: Beyond Journey\'s End');
      expect(result.year, 2023);
      expect(result.genres, ['Adventure', 'Drama', 'Fantasy']);
      expect(result.posterUrl, 'https://example.com/poster.jpg');
      expect(result.totalEpisodes, 28);
      expect(result.synopsis, 'Petualangan Frieren...');
      expect(result.format, 'TV');
    });
  });

  group('AniListApiService', () {
    test('query kosong mengembalikan list kosong', () async {
      final service = AniListApiService();
      final animeResults = await service.searchAnime('   ');
      final readingResults = await service.searchReading('   ');
      expect(animeResults, isEmpty);
      expect(readingResults, isEmpty);
    });

    test('searchAnime memetakan data GraphQL Anime dengan benar dan membersihkan tag HTML', () async {
      final mockJson = {
        'data': {
          'Page': {
            'media': [
              {
                'id': 116589,
                'title': {
                  'romaji': '86: Eighty Six',
                  'english': '86 EIGHTY-SIX',
                  'native': '86―エイティシックス―',
                },
                'startDate': {'year': 2021},
                'genres': ['Action', 'Drama', 'Mecha', 'Sci-Fi'],
                'episodes': 11,
                'format': 'TV',
                'coverImage': {
                  'large': 'https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx116589.jpg',
                },
                'description': 'Called <i>Juggernaut</i>.<br><br>Shin fights...',
              },
            ],
          },
        },
      };

      final client = MockClient((request) async {
        expect(request.url.host, 'graphql.anilist.co');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['variables']['search'], '86');
        return http.Response.bytes(
          utf8.encode(jsonEncode(mockJson)),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = AniListApiService(client: client);
      final results = await service.searchAnime('86');

      expect(results.length, 1);
      final item = results.first;
      expect(item.title, '86 EIGHTY-SIX');
      expect(item.year, 2021);
      expect(item.genres, ['Action', 'Drama', 'Mecha', 'Sci-Fi']);
      expect(item.totalEpisodes, 11);
      expect(item.format, 'TV');
      expect(item.posterUrl, 'https://s4.anilist.co/file/anilistcdn/media/anime/cover/medium/bx116589.jpg');
      expect(item.synopsis, 'Called Juggernaut.\n\nShin fights...');
    });

    test('searchReading memetakan chapters, volumes, dan format', () async {
      final mockJson = {
        'data': {
          'Page': {
            'media': [
              {
                'id': 105398,
                'title': {
                  'romaji': 'Na Honjaman Level Up',
                  'english': 'Solo Leveling',
                  'native': '나 혼자만 레벨업',
                },
                'startDate': {'year': 2018},
                'genres': ['Action', 'Adventure', 'Fantasy'],
                'chapters': 201,
                'volumes': 15,
                'format': 'MANGA',
                'coverImage': {
                  'large': 'https://s4.anilist.co/file/anilistcdn/media/manga/cover/medium/bx105398.jpg',
                },
                'description': 'Hunters fight monsters.',
              },
            ],
          },
        },
      };

      final client = MockClient((request) async {
        expect(request.url.host, 'graphql.anilist.co');
        return http.Response.bytes(
          utf8.encode(jsonEncode(mockJson)),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final service = AniListApiService(client: client);
      final results = await service.searchReading('Solo Leveling');

      expect(results.length, 1);
      final item = results.first;
      expect(item.title, 'Solo Leveling');
      expect(item.year, 2018);
      expect(item.genres, ['Action', 'Adventure', 'Fantasy']);
      expect(item.totalEpisodes, 201); // chapters di-map ke totalEpisodes
      expect(item.format, 'MANGA');
      expect(item.posterUrl, 'https://s4.anilist.co/file/anilistcdn/media/manga/cover/medium/bx105398.jpg');
      expect(item.synopsis, 'Hunters fight monsters.');
    });
  });

  group('TmdbApiService', () {
    test('query kosong mengembalikan list kosong', () async {
      final service = TmdbApiService(apiKey: 'dummy_key');
      final movies = await service.searchMovie('  ');
      final series = await service.searchSeries('  ');
      expect(movies, isEmpty);
      expect(series, isEmpty);
    });

    test('melempar Exception jika API key belum diatur', () {
      final service = TmdbApiService(apiKey: '');
      expect(() => service.searchMovie('Inception'), throwsA(isA<Exception>()));
      expect(
        () => service.searchSeries('Breaking Bad'),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'parsing respons Film TMDB memetakan genre ID dan poster path',
      () async {
        final mockJson = {
          'results': [
            {
              'title': 'Inception',
              'release_date': '2010-07-16',
              'genre_ids': [28, 878],
              'poster_path': '/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg',
              'overview': 'A thief who steals corporate secrets...',
            },
          ],
        };

        final client = MockClient((request) async {
          expect(request.url.host, 'api.themoviedb.org');
          expect(request.url.path, '/3/search/movie');
          return http.Response(jsonEncode(mockJson), 200);
        });

        final service = TmdbApiService(apiKey: 'test_key', client: client);
        final results = await service.searchMovie('Inception');

        expect(results.length, 1);
        final item = results.first;
        expect(item.title, 'Inception');
        expect(item.year, 2010);
        expect(item.genres, ['Action', 'Sci-Fi']);
        expect(
          item.posterUrl,
          'https://image.tmdb.org/t/p/w500/qmDpIHrmpJINaRKAfWQfftjCdyi.jpg',
        );
        expect(item.totalEpisodes, isNull);
        expect(item.synopsis, 'A thief who steals corporate secrets...');
      },
    );

    test(
      'parsing respons Series TMDB memetakan nama dan first_air_date',
      () async {
        final mockJson = {
          'results': [
            {
              'name': 'Breaking Bad',
              'first_air_date': '2008-01-20',
              'genre_ids': [18, 80],
              'poster_path': '/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
              'overview': 'Walter White, a New Mexico chemistry teacher...',
            },
          ],
        };

        final client = MockClient((request) async {
          expect(request.url.host, 'api.themoviedb.org');
          expect(request.url.path, '/3/search/tv');
          return http.Response(jsonEncode(mockJson), 200);
        });

        final service = TmdbApiService(apiKey: 'test_key', client: client);
        final results = await service.searchSeries('Breaking Bad');

        expect(results.length, 1);
        final item = results.first;
        expect(item.title, 'Breaking Bad');
        expect(item.year, 2008);
        expect(item.genres, ['Drama', 'Crime']);
        expect(
          item.posterUrl,
          'https://image.tmdb.org/t/p/w500/ggFHVNu6YYI5L9pCfOacjizRGt.jpg',
        );
      },
    );
  });
}
