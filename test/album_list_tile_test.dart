import 'package:album_display/album_list/bloc/album_list_bloc.dart';
import 'package:album_display/album_list/view/album_list_tile.dart';
import 'package:album_display/app_theme.dart';
import 'package:album_display/models/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'resources/demo_albums.dart';

class MockAlbumListBloc extends MockBloc<AlbumListEvent, AlbumListState>
    implements AlbumListBloc {}

void main() {
  group('Album list tile', () {
    late AlbumListBloc albumListBloc;

    setUp(() async {
      albumListBloc = MockAlbumListBloc();
      await loadAppFonts();
    });

    testGoldens('is favorited', (tester) async {
      whenListen(albumListBloc, Stream.fromIterable(<AlbumListState>[]),
          initialState: AlbumListState(
            favorites: const {1},
            albumData: demoAlbums,
          ));

      mockNetworkImagesFor(() => tester.pumpWidgetBuilder(
          BlocProvider.value(
            value: albumListBloc,
            child: AlbumListTile(demoAlbums.first),
          ),
          surfaceSize: const Size(400, 130),
          wrapper: materialAppWrapper(theme: appTheme)));
      await screenMatchesGolden(tester, 'album_list_tile_favorited');
    });

    testGoldens('is not favorited', (tester) async {
      whenListen(albumListBloc, Stream.fromIterable(<AlbumListState>[]),
          initialState: AlbumListState(
            favorites: const {},
            albumData: demoAlbums,
          ));

      mockNetworkImagesFor(() => tester.pumpWidgetBuilder(
          BlocProvider.value(
            value: albumListBloc,
            child: AlbumListTile(demoAlbums.first),
          ),
          surfaceSize: const Size(400, 130),
          wrapper: materialAppWrapper(theme: appTheme)));

      await screenMatchesGolden(tester, 'album_list_tile_not_favorited');
    });

    testGoldens('with long name', (tester) async {
      whenListen(albumListBloc, Stream.fromIterable(<AlbumListState>[]),
          initialState: AlbumListState(
            favorites: const {},
            albumData: demoAlbums,
          ));

      mockNetworkImagesFor(() => tester.pumpWidgetBuilder(
          BlocProvider.value(
              value: albumListBloc,
              child: AlbumListTile(Album(
                  id: 1,
                  imageUrl: '',
                  price: 6.99,
                  releaseDate: DateTime(2022, 2, 3),
                  name:
                      'This is a really long name for an album, it should wrap to multiple lines and still look as good as possible.'))),
          surfaceSize: const Size(400, 160),
          wrapper: materialAppWrapper(theme: appTheme)));

      await screenMatchesGolden(tester, 'album_list_tile_long_title');
    });

    testGoldens('with no price', (tester) async {
      whenListen(albumListBloc, Stream.fromIterable(<AlbumListState>[]),
          initialState: AlbumListState(
            favorites: const {},
            albumData: demoAlbums,
          ));

      mockNetworkImagesFor(() => tester.pumpWidgetBuilder(
          BlocProvider.value(
            value: albumListBloc,
            child: AlbumListTile(Album(
                id: 1,
                imageUrl: '',
                price: null,
                releaseDate: DateTime(2022, 2, 3),
                name:
                    'This is a an album without any price (which the API does support)')),
          ),
          surfaceSize: const Size(400, 140),
          wrapper: materialAppWrapper(theme: appTheme)));

      await screenMatchesGolden(tester, 'album_list_tile_no_price');
    });
  });
}
