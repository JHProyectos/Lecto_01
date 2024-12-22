import 'package:flutter/material.dart';

/// Enumeración de todas las rutas de navegación disponibles en la aplicación
enum AppRoute {
  login,
  home,
  pdfUpload,
  processing,
  playback,
  settings,
}

/// Extensión para convertir enum a String para las rutas de navegación
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
      default:
        return '/'; // Ruta por defecto
    }
  }

  String get name {
    return toString().split('.').last;
  }
}

/// Clase para manejar las rutas de recursos estáticos
class StaticResources {
  // Ruta centralizada para las traducciones
  static const String translationPath = 'assets/translations'; 
  
  // Ruta para las imágenes
  static const String imagesPath = 'assets/images'; 

  // Ruta para las fuentes personalizadas
  static const String fontsPath = 'assets/fonts';

  // Ruta para archivos de datos JSON (configuraciones o datos estáticos)
  static const String dataPath = 'assets/data'; 

  // Ruta para archivos de audio
  static const String audioPath = 'assets/audio'; 

  // Ruta para archivos de video
  static const String videoPath = 'assets/videos';

  // Ruta para los íconos personalizados
  static const String iconsPath = 'assets/icons'; 

  // Ruta para las animaciones Lottie
  static const String lottiePath = 'assets/lottie'; 

  // Ruta para bases de datos locales, si aplicas algún tipo de almacenamiento local como SQLite
  static const String databasePath = 'assets/database'; 
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
