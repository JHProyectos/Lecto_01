import 'package:flutter/material.dart';

/// Enumeración de todas las rutas disponibles en la aplicación
enum AppRoute {
  login,
  home,
  pdfUpload,
  processing,
  playback,
  settings
}

/// Extensión para convertir enum a String
extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.login:
        return '/login';
      case AppRoute.home:
        return '/home';
      case AppRoute.pdfUpload:
        return '/pdf-upload';
      case AppRoute.processing:
        return '/processing';
      case AppRoute.playback:
        return '/playback';
      case AppRoute.settings:
        return '/settings';
    }
  }

  String get name {
    return toString().split('.').last;
  }
}

/// Clase para manejar la navegación de la aplicación
class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState get navigator => navigatorKey.currentState!;

  /// Navega a una ruta con animación de fade
  static Future<T?> pushFadeRoute<T>({
    required Widget page,
    RouteSettings? settings,
  }) {
    return navigator.push<T>(
      PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Navega a una ruta con animación de slide
  static Future<T?> pushSlideRoute<T>({
    required Widget page,
    RouteSettings? settings,
  }) {
    return navigator.push<T>(
      PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  /// Navega y reemplaza la ruta actual
  static Future<T?> pushReplacementRoute<T>({
    required Widget page,
    RouteSettings? settings,
  }) {
    return navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => page,
        settings: settings,
      ),
    );
  }
}
