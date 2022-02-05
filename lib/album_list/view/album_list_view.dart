import 'package:album_display/album_list/bloc/album_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'album_list_tile.dart';

/// Displays a scrollable list of albums, using the latest state of
/// the nearest [AlbumListBloc] ancestor.
class AlbumListView extends StatelessWidget {
  /// This list view builds using the latest list of [Albums] in the state
  /// of the nearest [AlbumListBloc] ansestor.
  const AlbumListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final albums = context
        .select((AlbumListBloc albumListBloc) => albumListBloc.state.albumData);
    final errorState = context.select((AlbumListBloc albumListBloc) =>
        albumListBloc.state is AlbumListError
            ? albumListBloc.state as AlbumListError
            : null);

    if (errorState != null) {
      return _AlbumListErrorView(errorState.message);
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 20, top: 18.0),
          sliver: SliverToBoxAdapter(
            child: Text('${albums.length} albums'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 15, top: 5),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => AlbumListTile(albums[index]),
                  childCount: albums.length)),
        )
      ],
    );
  }
}

/// Simple error display widget accepting a short error message
/// and a button to refetch the album list in the nearest
/// ancestor [AlbumListBloc].
class _AlbumListErrorView extends StatelessWidget {
  /// Create a view for the given error message.
  const _AlbumListErrorView(this.errorMessage, {Key? key}) : super(key: key);

  /// A short error message.
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error retrieving albums, please try again.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 15),
            Text('Error message: $errorMessage'),
            const SizedBox(height: 40),
            TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                onPressed: () => BlocProvider.of<AlbumListBloc>(context)
                    .add(const LoadAlbumList()))
          ]),
    );
  }
}
