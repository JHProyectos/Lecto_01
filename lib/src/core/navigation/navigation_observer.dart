class AppNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Logging de navegación
    print('Nueva ruta: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Logging de navegación
    print('Ruta eliminada: ${route.settings.name}');
  }
}
