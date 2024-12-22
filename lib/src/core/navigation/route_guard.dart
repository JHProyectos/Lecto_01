import 'package:flutter/material.dart';
import '../auth/authentication_manager.dart';

class RouteGuard {
  static final AuthenticationManager _authManager = AuthenticationManager();

  /// Verifica si la ruta requiere autenticación
  static bool _requiresAuth(String routeName) {
    final publicRoutes = ['/login', '/register', '/forgot-password'];
    return !publicRoutes.contains(routeName);
  }

  /// Middleware para verificar autenticación antes de navegar
  static Route<dynamic>? guard(RouteSettings settings) {
    if (_requiresAuth(settings.name ?? '')) {
      return MaterialPageRoute(
        builder: (context) => FutureBuilder<bool>(
          future: _authManager.isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                // Usuario autenticado, continuar a la ruta solicitada
                return _buildRoute(settings)?.builder(context) ??
                    const Scaffold(body: Center(child: Text('Route not found')));
              } else {
                // Usuario no autenticado, redirigir al login
                return _buildRoute(
                  const RouteSettings(name: '/login'),
                )?.builder(context) ??
                    const Scaffold(body: Center(child: Text('Login route not found')));
              }
            }
            // Mientras se verifica la autenticación
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      );
    }
    // Ruta pública, no requiere autenticación
    return _buildRoute(settings);
  }

  /// Construye la ruta basada en los settings
  static MaterialPageRoute? _buildRoute(RouteSettings settings) {
    // Aquí defines tus rutas
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      // ... otras rutas
    }
    return null;
  }
}
