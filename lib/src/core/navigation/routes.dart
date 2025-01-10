// Suggested improvement for routes.dart
import 'package:flutter/material.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/utn_validation_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/upload/upload_page.dart';
import '../presentation/pages/processing/processing_page.dart';
import '../presentation/pages/playback/playback_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../data/models/playback_arguments.dart';

enum AppRoute {
  login('/login'),
  utnValidation('/utn-validation'),
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
      case '/login':
        return FadePageRoute(
          settings: settings,
          builder: (_) => const LoginPage(),
        );
      case '/utn-validation':
        return SlidePageRoute(
          settings: settings,
          builder: (_) => const UTNValidationPage(),
        );
      case '/home':
        return FadePageRoute(
          settings: settings,
          builder: (_) => const HomePage(),
        );
      case '/pdf-upload':
        return SlidePageRoute(
          settings: settings,
          builder: (_) => const UploadPage(),
        );
      case '/processing':
        return FadePageRoute(
          settings: settings,
          builder: (_) => ProcessingPage(
            fileName: settings.arguments as String,
          ),
        );
      case '/playback':
        return FadePageRoute(
          settings: settings,
          builder: (_) => PlaybackPage(
            arguments: settings.arguments as PlaybackArguments,
          ),
        );
      case '/settings':
        return SlidePageRoute(
          settings: settings,
          builder: (_) => const SettingsPage(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomePage(),
        );
    }
  }
}

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute({
    required this.builder,
    required RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: builder(context),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class SlidePageRoute<T> extends PageRoute<T> {
  SlidePageRoute({
    required this.builder,
    required RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilder builder;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: builder(context),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
