//lib/src/features/home/home_screen.dart:
// Widgets y funcionalidades básicas de Flutter
import 'package:flutter/material.dart';

// Localización
import 'package:easy_localization/easy_localization.dart';

// Navegación y rutas
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_route.dart';
import '../../core/navigation/page_transition.dart';

// Autenticación
import '../../core/auth/authentication_manager.dart';

// Gestión de temas
import '../../core/providers/theme_provider.dart';
import '../../core/theme/theme_config.dart';

// Widgets personalizados
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/language_selector.dart';

// Otras pantallas (para navegación)
import '../upload/upload_screen.dart';
import '../playback/playback_screen.dart';

/// Estado de la pantalla principal (Home).
class _HomeScreenState extends State<HomeScreen> {
  /// Gestor de autenticación para manejar el cierre de sesión.
  final AuthenticationManager _authManager = AuthenticationManager();

  /// Navega a la pantalla de carga de archivos.
  void _navigateToUpload() {
    AppNavigator.pushNamed(
      context,
      AppRoute.upload,
      transition: PageTransition.slide, // Transición de desplazamiento.
    );
  }

  /// Navega a la pantalla de reproducción de un archivo.
  ///
  /// [fileName]: Nombre del archivo a reproducir.
  void _navigateToPlayback(String fileName) {
    AppNavigator.pushNamed(
      context,
      AppRoute.playback,
      arguments: PlaybackScreenArguments(fileName: fileName), // Argumentos para la reproducción.
      transition: PageTransition.fade, // Transición de desvanecimiento.
    );
  }

  /// Maneja el cierre de sesión del usuario.
  ///
  /// Al cerrar sesión, redirige al usuario a la pantalla de inicio de sesión.
  void _handleLogout() async {
    await _authManager.signOut(); // Cierra la sesión actual.
    AppNavigator.pushReplacementNamed(
      context,
      AppRoute.login,
      transition: PageTransition.fade, // Transición de desvanecimiento.
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home.title'.tr()), // Título traducido.
        actions: [
          // Botón para cerrar sesión.
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout, // Llama a la función de cierre de sesión.
          ),
        ],
      ),
      body: Column(
        children: [
          // Botón para navegar a la pantalla de carga de archivos.
          ElevatedButton(
            onPressed: _navigateToUpload,
            child: Text('home.upload'.tr()), // Texto traducido.
          ),
          // Botón para navegar a la pantalla de reproducción.
          ElevatedButton(
            onPressed: () => _navigateToPlayback('example.pdf'), // Archivo de ejemplo.
            child: Text('home.playback'.tr()), // Texto traducido.
          ),
        ],
      ),
    );
  }
}
