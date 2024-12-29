/// Observador de navegación que registra eventos en un servicio de análisis.
/// Esto es útil para rastrear qué pantallas visitan los usuarios en la aplicación.
class AppNavigatorObserver extends NavigatorObserver {
  /// Instancia del servicio de análisis para registrar eventos.
  final Analytics _analytics;

  /// Constructor que recibe una instancia de [Analytics].
  AppNavigatorObserver(this._analytics);

  /// Se invoca cuando se realiza una nueva navegación.
  /// Registra el nombre y los argumentos de la nueva ruta.
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _analytics.logScreenView(
      screenName: route.settings.name ?? 'unknown', // Nombre de la ruta actual.
      screenClass: route.settings.arguments?.toString() ?? 'unknown', // Argumentos de la ruta actual.
    );
  }

  /// Se invoca cuando se elimina una ruta de la pila de navegación.
  /// Registra el nombre y los argumentos de la ruta anterior (si existe).
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _analytics.logScreenView(
        screenName: previousRoute.settings.name ?? 'unknown', // Ruta anterior.
        screenClass: previousRoute.settings.arguments?.toString() ?? 'unknown', // Argumentos de la ruta anterior.
      );
    }
  }
}
