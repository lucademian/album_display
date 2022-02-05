import 'package:album_display/album_list/bloc/album_list_bloc.dart';
import 'package:album_display/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

/// Extension to easily display a dollar string for
/// a double, i.e. 2.0000 -> '$2.00'.
extension ToDollarString on double {
  /// Display this number rounded to 2 decimals as a dollar amount.
  ///
  /// For example, 2.1893 will return '$2.19'.
  String toDollarString() => '\$' + toStringAsFixed(2);
}

/// Display a list tile for the given [Album], with an image, name,
/// release date, price, and favorite/unfavorite button.
class AlbumListTile extends StatelessWidget {
  /// Displays the given [Album] as a list tile.
  const AlbumListTile(this.album, {Key? key}) : super(key: key);

  /// The album to display.
  final Album album;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Theme.of(context).primaryColorDark, width: 1),
      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Theme.of(context).backgroundColor,
                child: Image.network(
                  album.imageUrl,
                  width: 100,
                  height: 100,
                ),
              )),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  album.name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  DateFormat.yMMMd().format(album.releaseDate),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(album.price?.toDollarString() ?? '\$ --'),
              ],
            ),
          ),
          _AlbumFavoriteButton(album),
        ],
      ),
    );
  }
}

/// The star button used for favoriting/unfavoriting albums.
///
/// Rebuilds only when the given album is favorited/unfavorited in
/// the nearest ancestor [AlbumListBloc].
class _AlbumFavoriteButton extends StatelessWidget {
  const _AlbumFavoriteButton(this.album, {Key? key}) : super(key: key);

  final Album album;

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select((AlbumListBloc albumListBloc) =>
        albumListBloc.state.favorites.contains(album.id));

    return LikeButton(
        bubblesColor: BubblesColor(
            dotPrimaryColor: Theme.of(context).primaryColor,
            dotSecondaryColor: Theme.of(context).primaryColorLight),
        circleColor: CircleColor(
            start: Theme.of(context).primaryColorDark,
            end: Theme.of(context).primaryColor),
        isLiked: isFavorite,
        likeBuilder: (isLiked) => Icon(
              isLiked ? Icons.star : Icons.star_border,
              color: Theme.of(context)
                  .primaryColor
                  .withOpacity(isLiked ? 1.0 : 0.5),
            ),
        onTap: (isLiked) async {
          BlocProvider.of<AlbumListBloc>(context).add(isLiked
              ? RemoveFavoriteAlbum(album.id)
              : AddFavoriteAlbum(album.id));
          return !isLiked;
        });
  }
}
