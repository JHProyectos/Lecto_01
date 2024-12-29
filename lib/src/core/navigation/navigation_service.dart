import 'package:flutter/material.dart';
import 'navigation_exception.dart';
import 'route_guard.dart';

/// Servicio centralizado para manejar la navegación y validaciones.
class NavigationService {
  /// Llave global para acceder al estado del `Navigator`.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Lista de `RouteGuard` para validar antes de navegar.
  final List<RouteGuard> _guards;

  /// Constructor que inicializa el servicio con los guardias de rutas.
  NavigationService(this._guards);

  /// Verifica si se permite la navegación a una ruta específica.
  Future<bool> canNavigate(String routeName, dynamic arguments) async {
    for (final guard in _guards) {
      if (!await guard.canActivate(routeName, arguments)) {
        return false; // Navegación no permitida.
      }
    }
    return true; // Navegación permitida.
  }

  /// Navega a una ruta específica, con validación previa.
  ///
  /// [route]: La ruta a la que se quiere navegar.
  /// [arguments]: Argumentos opcionales para la ruta.
  /// [replace]: Si es `true`, reemplaza la ruta actual en el stack.
  ///
  /// Retorna el resultado de la navegación.
  Future<T?> navigateTo<T>(
    AppRoute route, {
    Object? arguments,
    bool replace = false,
  }) async {
    final routeName = route.path;

    // Validar si la navegación está permitida.
    if (!await canNavigate(routeName, arguments)) {
      throw NavigationException('Navegación no permitida', routeName);
    }

    // Realizar la navegación.
    if (replace) {
      return navigatorKey.currentState
          ?.pushReplacementNamed(routeName, arguments: arguments);
    }
    return navigatorKey.currentState
        ?.pushNamed(routeName, arguments: arguments);
  }
}
