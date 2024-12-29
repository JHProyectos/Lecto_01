/// Clase para manejar excepciones relacionadas con la navegación.
class NavigationException implements Exception {
  /// Mensaje descriptivo del error.
  final String message;

  /// Nombre de la ruta relacionada con el error, si aplica.
  final String? routeName;

  /// Constructor para inicializar la excepción.
  NavigationException(this.message, [this.routeName]);

  /// Devuelve una representación en texto de la excepción.
  @override
  String toString() {
    return 'NavigationException: $message'
        '${routeName != null ? ' (Ruta: $routeName)' : ''}';
  }
}
