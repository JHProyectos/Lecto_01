//lib/src/shared/utils/file_uploader.dart
enum PageTransition {
  fade,
  slide,
  scale;
  
  /// Crea una ruta personalizada con la transición especificada.
  ///
  /// [page]: La nueva pantalla que se debe mostrar.
  /// [settings]: Configuración de la ruta, como el nombre de la misma.
  ///
  /// Devuelve un `PageRoute` configurado con la transición especificada.
  PageRoute<T> createRoute<T>(Widget page, RouteSettings settings) {
    switch (this) {
      case PageTransition.fade:
        // Implementación de transición de desvanecimiento (Fade).
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case PageTransition.slide:
        // Implementación de transición deslizante (Slide).
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0), // La pantalla entra desde la derecha.
                end: Offset.zero, // Posición final: en el centro.
              ).animate(animation),
              child: child,
            );
          },
        );
      case PageTransition.scale:
        // Implementación de transición de escalado (Scale).
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(scale: animation, child: child);
          },
        );
    }
  }
}
