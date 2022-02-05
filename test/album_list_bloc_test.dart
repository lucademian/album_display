import 'package:album_display/album_list/bloc/album_list_bloc.dart';
import 'package:album_display/repositories/repositories.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'demo_repositories/fake_favorites_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'resources/demo_albums.dart';
import 'album_list_bloc_test.mocks.dart';

@GenerateMocks([AlbumRepository])
void main() async {
  late final FavoritesRepository favoritesRepository;
  late AlbumRepository albumRepository;
  setUpAll(() async {
    favoritesRepository = FakeFavoritesRepository();
  });

  setUp(() {
    albumRepository = MockAlbumRepository();
    when(albumRepository.getAlbumsForArtist())
        .thenAnswer((_) async => demoAlbums);
  });

  group('AlbumListBloc', () {
    blocTest(
      'emits nothing initially',
      build: () => AlbumListBloc(albumRepository, favoritesRepository),
      expect: () => [],
    );

    blocTest(
      'emits loaded albums when LoadAlbums is added',
      build: () => AlbumListBloc(albumRepository, favoritesRepository),
      act: (AlbumListBloc bloc) => bloc.add(const LoadAlbumList()),
      expect: () => [
        AlbumListState(favorites: const {}, albumData: demoAlbums),
      ],
    );

    blocTest(
      'emits error when LoadAlbums fetch fails',
      build: () {
        when(albumRepository.getAlbumsForArtist())
            .thenThrow(FetchAlbumError('error'));
        return AlbumListBloc(albumRepository, favoritesRepository);
      },
      act: (AlbumListBloc bloc) => bloc.add(const LoadAlbumList()),
      expect: () => [const AlbumListError('error')],
    );

    blocTest('emits favorited album and saves to storage',
        build: () => AlbumListBloc(albumRepository, favoritesRepository)
          ..add(const LoadAlbumList()),
        act: (AlbumListBloc bloc) => bloc.add(const AddFavoriteAlbum(1)),
        expect: () => [
              AlbumListState(favorites: const {1}, albumData: demoAlbums)
            ],
        verify: (bloc) {
          expect(favoritesRepository.getSavedFavorites(), contains(1));
        });

    blocTest('emits loaded favorited albums from storage',
        build: () => AlbumListBloc(albumRepository, favoritesRepository),
        act: (AlbumListBloc bloc) => bloc.add(const LoadAlbumList()),
        expect: () => [
              AlbumListState(favorites: const {1}, albumData: demoAlbums)
            ],
        verify: (bloc) {
          expect(favoritesRepository.getSavedFavorites(), contains(1));
        });

    blocTest('emits unfavorited album and saves to storage',
        build: () => AlbumListBloc(albumRepository, favoritesRepository)
          ..add(const LoadAlbumList()),
        act: (AlbumListBloc bloc) => bloc.add(const RemoveFavoriteAlbum(1)),
        expect: () =>
            [AlbumListState(favorites: const {}, albumData: demoAlbums)],
        verify: (bloc) {
          expect(favoritesRepository.getSavedFavorites().contains(1), isFalse);
        });

    blocTest('emits loaded favorited albums from storage after removing one',
        build: () => AlbumListBloc(albumRepository, favoritesRepository),
        act: (AlbumListBloc bloc) => bloc.add(const LoadAlbumList()),
        expect: () =>
            [AlbumListState(favorites: const {}, albumData: demoAlbums)],
        verify: (bloc) {
          expect(favoritesRepository.getSavedFavorites().contains(1), isFalse);
        });

    blocTest('emits multiple favorited albums and saves to storage',
        build: () => AlbumListBloc(albumRepository, favoritesRepository)
          ..add(const LoadAlbumList()),
        act: (AlbumListBloc bloc) => bloc
          ..add(const AddFavoriteAlbum(1))
          ..add(const AddFavoriteAlbum(2))
          ..add(const AddFavoriteAlbum(2))
          ..add(const AddFavoriteAlbum(2))
          ..add(const AddFavoriteAlbum(3)),
        expect: () => [
              AlbumListState(favorites: const {1, 2, 3}, albumData: demoAlbums)
            ],
        verify: (bloc) {
          expect(favoritesRepository.getSavedFavorites(), equals({1, 2, 3}));
        });
  });
}
