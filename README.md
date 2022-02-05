# Ed Sheeran Album Display

A simple Flutter application for displaying all of Ed Sheeran's albums, allowing users
to favorite/unfavorite albums (which is stored locally using Hive).

## Getting Started

1. Install packages: `flutter pub get`
2. Generate code: `flutter pub run build_runner build`
3. If running on web, you need to disable strict CORS checking in your
browser. The best method I've found is to install [flutter_cors](https://pub.dev/packages/flutter_cors) (`flutter pub global activate flutter_cors`) and then run `fluttercors --disable` to disable strict CORS checking in your debugging Chrome instance (Note: only works when debugging in Chrome).
4. Launch the app with `flutter run`

Note: this application has been tested on web and on Android emulator, but not on device due to technical limitations.
