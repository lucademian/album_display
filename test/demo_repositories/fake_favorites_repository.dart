import 'package:album_display/repositories/favorites_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// This [FavoritesRepository] implementation uses a simple private
/// field to store favorites, and is intended for testing.
class FakeFavoritesRepository extends Fake implements FavoritesRepository {
  FakeFavoritesRepository([Set<int>? favorites]) : _favorites = favorites ?? {};
  final Set<int> _favorites;

  @override
  Future<void> addFavorite(int albumId) async => _favorites.add(albumId);

  @override
  Set<int> getSavedFavorites() => _favorites;

  @override
  Future<void> removeFavorite(int albumId) async => _favorites.remove(albumId);
}
