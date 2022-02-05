import 'package:album_display/models/models.dart';
import 'package:album_display/repositories/repositories.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'album_list_event.dart';
part 'album_list_state.dart';
part 'album_list_bloc.g.dart';

/// This Bloc connects the favorites storage repository and the
/// album repository to the frontend, maintaining a state
/// with favorited album IDs and loaded album data.
class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  /// Create a bloc to connect the two given repositories with the
  /// frontend.
  ///
  /// Note: to complete intialization, the event [LoadAlbumList]
  /// should be added after creation to load data from the two repos.
  AlbumListBloc(this.albumRepository, this.favoritesRepository)
      : super(const AlbumListState()) {
    on<AddFavoriteAlbum>(_addFavoriteAlbum);
    on<RemoveFavoriteAlbum>(_removeFavoriteAlbum);
    on<LoadAlbumList>(_loadAlbumList);
  }

  /// The [AlbumRepository] to retrieve album data from.
  final AlbumRepository albumRepository;

  /// The [FavoritesRepository] to save and retrieve favorites from.
  final FavoritesRepository favoritesRepository;

  /// Load all albums from the album repository and all favorites
  /// from the favorites repository and emit a state with them loaded.
  ///
  /// This discards the previous values of the state, and should only
  /// be done when initializing or re-initializing the state.
  Future<void> _loadAlbumList(
      LoadAlbumList event, Emitter<AlbumListState> emit) async {
    try {
      emit(state.copyWith(
          favorites: favoritesRepository.getSavedFavorites(),
          albumData: await albumRepository.getAlbumsForArtist()));
    } on FetchAlbumError catch (e) {
      emit(AlbumListError(e.message));
    } catch (e) {
      emit(const AlbumListError('Unknown Error'));
    }
  }

  /// Adds the album in the event to the state's set of favorites
  /// and updates the favorites store.
  Future<void> _addFavoriteAlbum(
      AddFavoriteAlbum event, Emitter<AlbumListState> emit) async {
    await favoritesRepository.addFavorite(event.albumId);
    emit(state.copyWith.favorites(favoritesRepository.getSavedFavorites()));
  }

  /// Removes the album in the event from the state's set of favorites
  /// and updates the favorites store.
  Future<void> _removeFavoriteAlbum(
      RemoveFavoriteAlbum event, Emitter<AlbumListState> emit) async {
    await favoritesRepository.removeFavorite(event.albumId);
    emit(state.copyWith.favorites(favoritesRepository.getSavedFavorites()));
  }
}
