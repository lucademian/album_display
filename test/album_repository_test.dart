import 'dart:io';

import 'package:album_display/models/models.dart';
import 'package:album_display/repositories/repositories.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('Album repository', () {
    late String mockResponse;

    setUpAll(() async {
      // This is copied directly from iTunes API for testing.
      final mockApiResponseFile = File('test/resources/mock_api_response.json');
      mockResponse = await mockApiResponseFile.readAsString();
    });

    test('fetch album list', () async {
      final dio = Dio();
      final dioAdapter = DioAdapter(dio: dio);
      dioAdapter.onGet(
        AlbumRepository.apiUrl,
        (server) => server.reply(200, mockResponse),
      );
      final albumListRepo = AlbumRepository(dio);
      final albums = await albumListRepo.getAlbumsForArtist();
      expect(
          albums,
          equals([
            Album(
                id: 1193701079,
                price: 12.99,
                name: '÷ (Deluxe)',
                imageUrl:
                    'https://is5-ssl.mzstatic.com/image/thumb/Music115/v4/30/bd/76/30bd76b9-ceb9-2f8a-6821-ee8ea016bbfd/source/100x100bb.jpg',
                releaseDate: DateTime.parse('2017-03-03T08:00:00Z')),
            Album(
                id: 448213992,
                price: 11.99,
                name: '+ (Deluxe Version)',
                imageUrl:
                    'https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/0f/b9/8a/0fb98a37-e1d9-a78b-e162-713e73f36011/source/100x100bb.jpg',
                releaseDate: DateTime.parse('2011-09-09T07:00:00Z')),
            Album(
                id: 858518077,
                price: 10.99,
                name: 'x',
                imageUrl:
                    'https://is5-ssl.mzstatic.com/image/thumb/Music4/v4/5d/1f/56/5d1f56ae-fa9d-8ae4-724e-172504571be4/source/100x100bb.jpg',
                releaseDate: DateTime.parse('2014-06-20T07:00:00Z')),
            Album(
                id: 448214084,
                price: 6.99,
                name: '+',
                imageUrl:
                    'https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/ca/b4/d0/cab4d08c-10f7-f5dd-6274-6221b43fd650/source/100x100bb.jpg',
                releaseDate: DateTime.parse('2011-09-09T07:00:00Z')),
            Album(
                id: 1464549183,
                price: 11.99,
                name: 'No.6 Collaborations Project',
                imageUrl:
                    'https://is4-ssl.mzstatic.com/image/thumb/Music113/v4/89/d3/71/89d371d2-ac34-5e47-deff-6258e6218ceb/source/100x100bb.jpg',
                releaseDate: DateTime.parse('2019-07-12T07:00:00Z'))
          ]));
    });

    test('fetch album list throws HTTP error on invalid response code',
        () async {
      final dio = Dio();
      final dioAdapter = DioAdapter(dio: dio);
      dioAdapter.onGet(
        AlbumRepository.apiUrl,
        (server) => server.reply(500, ''),
      );
      final albumListRepo = AlbumRepository(dio);
      expect(
          () => albumListRepo.getAlbumsForArtist(),
          throwsA(predicate((e) =>
              e is FetchAlbumError && e.message == 'Http status error [500]')));
    });

    test('fetch album list throws JSON error on invalid response JSON',
        () async {
      final dio = Dio();
      final dioAdapter = DioAdapter(dio: dio);
      dioAdapter.onGet(
        AlbumRepository.apiUrl,
        (server) => server.reply(200, ']this is invalid json['),
      );
      final albumListRepo = AlbumRepository(dio);
      expect(
          () => albumListRepo.getAlbumsForArtist(),
          throwsA(predicate(
              (e) => e is FetchAlbumError && e.message == 'JSON Error')));
    });
  });
}
