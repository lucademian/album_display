import 'dart:convert';

import 'package:album_display/constants.dart';
import 'package:album_display/models/models.dart';
import 'package:dio/dio.dart';

/// Repository for fetching album data to display.
///
/// The default implemenation uses the iTunes API, and can be
/// implemented to source data from different sources.
///
/// The default implementation uses [Dio] for http requests.
class AlbumRepository {
  /// Create an album repository with the given [Dio] client,
  /// or a default one.
  AlbumRepository([Dio? client]) : _client = client ?? Dio();

  /// Client to use for http requests.
  final Dio _client;

  /// Base API URL
  static const apiUrl = 'https://itunes.apple.com/lookup';

  /// Gets the list of all albums from the data API.
  Future<List<Album>> getAlbumsForArtist() async {
    try {
      final res = await _client.get(apiUrl, queryParameters: {
        'id': artistId,
        'entity': 'album',
        'limit': 200, // max number to load from API is 200
      });
      final data = jsonDecode(res.data);

      // filter out non-album collections
      final albumList = List<Map>.from(data['results']).where((doc) =>
          doc['wrapperType'] == 'collection' &&
          doc['collectionType'] == 'Album');

      // convert to Album objects
      return albumList
          .map((doc) => Album(
              id: doc['collectionId'],
              name: doc['collectionName'],
              imageUrl: doc['artworkUrl100'],
              price: doc['collectionPrice'],
              releaseDate: DateTime.parse(doc['releaseDate'])))
          .toList();
    } on DioError catch (e) {
      throw FetchAlbumError(e.message);
    } on FormatException catch (_) {
      throw FetchAlbumError('JSON Error');
    } catch (_) {
      throw FetchAlbumError();
    }
  }
}

/// Any error encountered while fetching albums, with an optional
/// error message.
class FetchAlbumError extends Error {
  /// Create a [FetchAlbumError] with an optional message.
  FetchAlbumError([this.message = 'Unknown Error']);

  /// Brief description of error.
  final String message;
}
