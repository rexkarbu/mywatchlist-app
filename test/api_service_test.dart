import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:my_watchlist/models/api_search_result.dart';
import 'package:my_watchlist/services/jikan_api_service.dart';
import 'package:my_watchlist/services/tmdb_api_service.dart';

void main() {
  group('ApiSearchResult Model', () {
    test('properti terisi dengan benar', () {
      const result = ApiSearchResult(
        title: 'Frieren: Beyond Journey\'s End',
        year: 2023,
        genres: ['Adventure', 'Drama', 'Fantasy'],
        posterUrl: 'https://example.com/poster.jpg',
        totalEpisodes: 28,
        synopsis: 'Petualangan Frieren...',
      );

      expect(result.title, 'Frieren: Beyond Journey\'s End');
      expect(result.year, 2023);
      expect(result.genres, ['Adventure', 'Drama', 'Fantasy']);
      expect(result.posterUrl, 'https://example.com/poster.jpg');
      expect(result.totalEpisodes, 28);
      expect(result.synopsis, 'Petualangan Frieren...');
    });
  });

  group('JikanApiService', () {
    test('query kosong mengembalikan list kosong', () async {
      final service = JikanApiService();
      final results = await service.searchAnime('   ');
      expect(results, isEmpty);
    });

    test('parsing respons Jikan v4 berhasil memetakan semua bidang', () async {
      final mockJson = {
        'data': [
          {
            'title': 'Sousou no Frieren',
            'title_english': 'Frieren: Beyond Journey\'s End',
            'year': 2023,
            'episodes': 28,
            'synopsis': 'The anime adaptation of Frieren.',
            'genres': [
              {'name': 'Adventure'},
              {'name': 'Fantasy'},
            ],
            'themes': [
              {'name': 'Time'},
            ],
            'images': {
              'jpg': {
                'image_url':
                    'https://cdn.myanimelist.net/images/anime/4/84155.jpg',
                'large_image_url':
                    'https://cdn.myanimelist.net/images/anime/4/84155l.jpg',
              },
            },
          },
        ],
      };

      final client = MockClient((request) async {
        expect(request.url.host, 'api.jikan.moe');
        expect(request.url.path, '/v4/anime');
        return http.Response(jsonEncode(mockJson), 200);
      });

      final service = JikanApiService(client: client);
      final results = await service.searchAnime('frieren');

      expect(results.length, 1);
      final item = results.first;
      expect(item.title, 'Frieren: Beyond Journey\'s End');
      expect(item.year, 2023);
      expect(item.totalEpisodes, 28);
      expect(item.genres, ['Adventure', 'Fantasy', 'Time']);
      expect(
        item.posterUrl,
        'https://cdn.myanimelist.net/images/anime/4/84155l.jpg',
      );
      expect(item.synopsis, 'The anime adaptation of Frieren.');
    });

    test('fallback ke aired.prop.from.year jika year bernilai null', () async {
      final mockJson = {
        'data': [
          {
            'title': 'Classic Anime',
            'title_english': null,
            'year': null,
            'aired': {
              'prop': {
                'from': {'year': 1998},
              },
            },
            'genres': [],
            'images': null,
          },
        ],
      };

      final client = MockClient((request) async {
        return http.Response(jsonEncode(mockJson), 200);
      });

      final service = JikanApiService(client: client);
      final results = await service.searchAnime('classic');

      expect(results.first.title, 'Classic Anime');
      expect(results.first.year, 1998);
      expect(results.first.posterUrl, isNull);
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
