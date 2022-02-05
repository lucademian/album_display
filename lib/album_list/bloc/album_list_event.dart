part of 'album_list_bloc.dart';

/// Base type for [AlbumListBloc] events.
abstract class AlbumListEvent extends Equatable {
  const AlbumListEvent();

  @override
  List<Object> get props => [];
}

/// Load the album data and the favorites data from each corresponding
/// data repository.
class LoadAlbumList extends AlbumListEvent {
  const LoadAlbumList();
}

/// Add this album ID to the set of favorited album IDs.
class AddFavoriteAlbum extends AlbumListEvent {
  const AddFavoriteAlbum(this.albumId);

  /// Album ID to add.
  final int albumId;

  @override
  List<Object> get props => [albumId];
}

/// Remove this album ID from the set of favorited album IDs.
class RemoveFavoriteAlbum extends AlbumListEvent {
  const RemoveFavoriteAlbum(this.albumId);

  /// Album ID to remove.
  final int albumId;

  @override
  List<Object> get props => [albumId];
}
