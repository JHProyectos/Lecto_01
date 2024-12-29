// Suggested improvement for routes.dart
enum AppRoute {
  login('/login'),
  home('/home'),
  pdfUpload('/pdf-upload'),
  processing('/processing'),
  playback('/playback'),
  settings('/settings');

  final String path;
  const AppRoute(this.path);
}

class AppNavigator {
  static Future<T?> pushNamed<T>(
    BuildContext context,
    AppRoute route, {
    Object? arguments,
    bool replace = false,
  }) {
    final routeName = route.path;
    if (replace) {
      return Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    }
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  // Add custom transitions
  static PageRoute getPageRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/upload':
        return SlidePageRoute(
          settings: settings,
          builder: (_) => const UploadScreen(),
        );
      case '/playback':
        return FadePageRoute(
          settings: settings,
          builder: (_) => PlaybackScreen(
            arguments: settings.arguments as PlaybackScreenArguments,
          ),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
    }
  }
}
