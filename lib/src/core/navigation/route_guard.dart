/// Clase abstracta que define un contrato para los guardianes de rutas.
/// Los guardianes son responsables de determinar si se puede acceder a una ruta específica.
abstract class RouteGuard {
  /// Método que verifica si se permite activar (navegar a) una ruta específica.
  /// 
  /// [routeName]: El nombre de la ruta que se desea acceder.
  /// [arguments]: Los argumentos asociados con la navegación a la ruta.
  /// 
  /// Devuelve `true` si se permite navegar a la ruta, de lo contrario `false`.
  Future<bool> canActivate(String routeName, dynamic arguments);
}

/// Guardián específico para verificar la autenticación del usuario.
/// Se asegura de que ciertas rutas solo sean accesibles si el usuario está autenticado.
class AuthGuard implements RouteGuard {
  /// Instancia del administrador de autenticación, responsable de manejar 
  /// la información de inicio de sesión del usuario.
  final AuthenticationManager _authManager;

  /// Constructor que recibe una instancia de [AuthenticationManager].
  AuthGuard(this._authManager);

  /// Método que verifica si el usuario tiene acceso a una ruta específica.
  /// 
  /// [routeName]: El nombre de la ruta que se desea acceder.
  /// [arguments]: Los argumentos asociados con la navegación a la ruta.
  /// 
  /// Devuelve `true` si el usuario está autenticado o si la ruta es pública 
  /// (por ejemplo, `/login`). Devuelve `false` si el usuario no está autenticado 
  /// y trata de acceder a una ruta protegida.
  @override
  Future<bool> canActivate(String routeName, dynamic arguments) async {
    // Verifica si el usuario está autenticado mediante el administrador de autenticación.
    final isAuthenticated = await _authManager.isAuthenticated();

    // Si el usuario no está autenticado y la ruta no es la de login, bloquea el acceso.
    if (!isAuthenticated && routeName != '/login') {
      return false;
    }

    // Permite el acceso en cualquier otro caso.
    return true;
  }
}
