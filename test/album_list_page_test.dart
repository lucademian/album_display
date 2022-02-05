import 'package:album_display/album_list/view/album_list_page.dart';
import 'package:album_display/app_theme.dart';
import 'package:album_display/repositories/repositories.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:like_button/like_button.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'demo_repositories/fake_favorites_repository.dart';
import 'resources/demo_albums.dart';
import 'album_list_page_test.mocks.dart';

@GenerateMocks([AlbumRepository])
void main() {
  group('Album list page', () {
    late AlbumRepository albumRepository;
    late FakeFavoritesRepository favoritesRepository;

    Widget wrapWidgetWithRepositories(Widget child) => RepositoryProvider.value(
          value: albumRepository,
          child: RepositoryProvider<FavoritesRepository>.value(
              value: favoritesRepository, child: child),
        );
    setUp(() async {
      albumRepository = MockAlbumRepository();
      favoritesRepository = FakeFavoritesRepository();

      when(albumRepository.getAlbumsForArtist())
          .thenAnswer((_) async => demoAlbums);

      await loadAppFonts();
    });

    testGoldens('no favorites', (tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidgetBuilder(
          wrapWidgetWithRepositories(const AlbumListPage()),
          surfaceSize: const Size(400, 800),
          wrapper: materialAppWrapper(theme: appTheme)));
      // await tester.pump(Duration(seconds: 1));
      await screenMatchesGolden(tester, 'album_list_page_no_favorites');
    });

    testGoldens('with favorites', (tester) async {
      favoritesRepository = FakeFavoritesRepository({2, 3, 5});
      await mockNetworkImagesFor(() => tester.pumpWidgetBuilder(
          wrapWidgetWithRepositories(const AlbumListPage()),
          surfaceSize: const Size(400, 800),
          wrapper: materialAppWrapper(theme: appTheme)));
      await screenMatchesGolden(tester, 'album_list_page_with_favorites');
    });

    testGoldens('with scrolling', (tester) async {
      when(albumRepository.getAlbumsForArtist())
          .thenAnswer((_) async => [...demoAlbums, demoAlbums.first]);
      await mockNetworkImagesFor(() => tester.pumpWidgetBuilder(
          wrapWidgetWithRepositories(const AlbumListPage()),
          surfaceSize: const Size(400, 800),
          wrapper: materialAppWrapper(theme: appTheme)));
      await screenMatchesGolden(tester, 'album_list_page_with_scrolling');
    });

    testGoldens('with error', (tester) async {
      when(albumRepository.getAlbumsForArtist())
          .thenThrow(FetchAlbumError('Test Error'));
      await mockNetworkImagesFor(() => tester.pumpWidgetBuilder(
          wrapWidgetWithRepositories(const AlbumListPage()),
          surfaceSize: const Size(400, 800),
          wrapper: materialAppWrapper(theme: appTheme)));
      await screenMatchesGolden(tester, 'album_list_page_with_error');
    });

    testWidgets('can use favorite buttons', (tester) async {
      await mockNetworkImagesFor(() => tester.pumpWidgetBuilder(
          wrapWidgetWithRepositories(const AlbumListPage()),
          surfaceSize: const Size(400, 800),
          wrapper: materialAppWrapper(theme: appTheme)));

      expect(favoritesRepository.getSavedFavorites(), equals(<int>{}));
      await tester.tap(find.byType(LikeButton).at(2));
      await tester.pumpAndSettle();
      expect(favoritesRepository.getSavedFavorites(), equals({3}));
      await tester.tap(find.byType(LikeButton).at(3));
      await tester.pumpAndSettle();
      expect(favoritesRepository.getSavedFavorites(), equals({3, 4}));
      await tester.tap(find.byType(LikeButton).at(3));
      await tester.pumpAndSettle();
      expect(favoritesRepository.getSavedFavorites(), equals({3}));
    });
  });
}
