import 'package:album_display/album_list/bloc/album_list_bloc.dart';
import 'package:album_display/album_list/view/album_list_view.dart';
import 'package:album_display/constants.dart';
import 'package:album_display/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This widget provides an [AlbumListBloc] to it's descendants,
/// and displays an [AlbumListView] inside a [Scaffold] with a
/// count of favorited albums in the app bar.
class AlbumListPage extends StatelessWidget {
  const AlbumListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumListBloc(
          RepositoryProvider.of<AlbumRepository>(context),
          RepositoryProvider.of<FavoritesRepository>(context))
        ..add(const LoadAlbumList()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("$artistName's Albums"),
          actions: const [
            Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: _AlbumFavoriteCounter())
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: const AlbumListView(),
      ),
    );
  }
}

/// This widget displays a count of how many albums are favorited in the
/// nearest [AlbumListBloc] ancestor, and rebuilds only when that count
/// changes.
class _AlbumFavoriteCounter extends StatelessWidget {
  const _AlbumFavoriteCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // depend only on the count of favorites.
    final favoriteCount = context.select((AlbumListBloc albumListBloc) =>
        albumListBloc.state is AlbumListError
            ? null
            : albumListBloc.state.favorites.length);
    if (favoriteCount == null) {
      return const SizedBox();
    }
    return Center(
      child: Text('Favorites: $favoriteCount'),
    );
  }
}
