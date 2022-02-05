import 'package:album_display/album_list/view/album_list_page.dart';
import 'package:album_display/app_theme.dart';
import 'package:album_display/constants.dart';
import 'package:album_display/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Run the album list app
void main() async {
  await Hive.initFlutter();
  if (!Hive.isBoxOpen(favoriteAlbumBox)) {
    await Hive.openBox<int>(favoriteAlbumBox);
  }
  runApp(const AlbumListApp());
}

/// App displaying a list of albums with the ability to favorite/unfavorite
/// them.
///
/// This widget provides an [AlbumRepository] and a [FavoriteRepository]
/// to descendants for data sourcing.
class AlbumListApp extends StatelessWidget {
  const AlbumListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AlbumRepository(),
      child: RepositoryProvider(
        create: (context) => FavoritesRepository(),
        child: MaterialApp(
          title: "$artistName's Albums",
          theme: appTheme,
          home: const AlbumListPage(),
        ),
      ),
    );
  }
}
