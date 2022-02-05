import 'package:album_display/constants.dart';
import 'package:hive/hive.dart';

/// Store and retrieve a set of favorited album IDs.
///
/// The default implementation use [Hive] for persistent data storage,
/// and this class can be implemented to use different data stores.
class FavoritesRepository {
  /// Construct a [FavoritesRepository] that uses [Hive] to persistently
  /// store favorites. Can optionally specify a storage box name, or
  /// by default use [favoriteAlbumBox].
  FavoritesRepository([String? boxName])
      : _storageBox = Hive.box(boxName ?? favoriteAlbumBox);

  /// [Hive] box to store favorited album IDs inside.
  final Box<int> _storageBox;

  /// Get the [Set] of album IDs that have been favorited.
  Set<int> getSavedFavorites() => _storageBox.values.toSet();

  /// Add the given album ID to the set of favorited album IDs.
  Future<void> addFavorite(int albumId) => _storageBox.add(albumId);

  /// Remove the given album ID from the set of favorited album IDs.
  Future<void> removeFavorite(int albumId) async {
    // The Hive box doesn't maintain the set uniqueness property, so make
    // sure that all values are removed so that this repository
    // behaves as a set.
    final storageKeys = _storageBox
        .toMap()
        .entries
        .where((e) => e.value == albumId)
        .map((e) => e.key);
    await _storageBox.deleteAll(storageKeys);
  }
}
