part of 'album_list_bloc.dart';

/// State with all the needed data to display the album list.
@CopyWith()
class AlbumListState extends Equatable {
  /// Construct a state with the given data, by default an empty
  /// set of favorites and an empty list of display albums.
  const AlbumListState({this.favorites = const {}, this.albumData = const []});

  /// The set of favorited album IDs.
  final Set<int> favorites;

  /// The list of albums that are loaded.
  final List<Album> albumData;

  @override
  List<Object> get props => [favorites, albumData];
}

/// State emitted when an error occurs, with a short message explaining
/// what happened.
class AlbumListError extends AlbumListState {
  /// Create an error state with the given error message,
  /// or "Unknown Error" by default.
  const AlbumListError([this.message = 'Unknown Error']);

  /// A short message describing the error.
  final String message;

  @override
  List<Object> get props => [message, ...super.props];
}
