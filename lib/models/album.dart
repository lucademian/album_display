import 'package:equatable/equatable.dart';

/// Data model for an Album to display.
class Album extends Equatable {
  /// Construct an album with an optional price.
  const Album({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.releaseDate,
    this.price,
  });

  /// The unique ID of this album.
  final int id;

  /// The album name.
  final String name;

  /// URL to a 100x100 thumbnail for this album.
  final String imageUrl;

  /// Optional album price, set to `null` for no price.
  final double? price;

  /// Date this album was released.
  final DateTime releaseDate;

  @override
  List<Object?> get props => [name, imageUrl, price, releaseDate];
}
