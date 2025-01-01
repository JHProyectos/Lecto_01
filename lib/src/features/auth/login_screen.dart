// lib/src/features/auth/login_screen.dart
// Imports básicos de Flutter y paquetes externos
import 'package:flutter/material.dart'; // Proporciona los widgets básicos de Flutter
import 'package:provider/provider.dart'; // Para el manejo de estado con Provider
import 'package:easy_localization/easy_localization.dart'; // Para la internacionalización

// Imports relacionados con la navegación
import '../../core/navigation/app_navigator.dart'; // Para la navegación estandarizada
import '../../core/navigation/app_route.dart'; // Contiene las rutas de la aplicación
import '../../core/navigation/page_transition.dart'; // Para las transiciones de página personalizadas

// Imports relacionados con la autenticación y manejo de errores
import '../../core/auth/authentication_manager.dart'; // Maneja la autenticación
import '../../core/error/error_handler.dart'; // Maneja los errores de autenticación

// Imports relacionados con el tema
import '../../core/providers/theme_provider.dart'; // Proveedor para el manejo del tema
import '../../core/theme/theme_config.dart'; // Configuración del tema

// Imports de widgets y layouts personalizados
import '../../shared/layouts/login_screen_layout.dart'; // Layout personalizado para la pantalla de login
import '../../shared/widgets/language_selector.dart'; // Selector de idioma
import '../../shared/widgets/email_password_form.dart'; // Formulario de email y contraseña

// Imports de otras pantallas (para tipado en la navegación)
import '../home/home_screen.dart'; // Pantalla de inicio

/// Estado de la pantalla de inicio de sesión.
class _LoginScreenState extends State<LoginScreen> {
  /// Gestor de autenticación para manejar el inicio de sesión.
  final AuthenticationManager _authManager = AuthenticationManager();

  /// Indica si se está procesando una operación de carga.
  bool _isLoading = false;

  /// Almacena mensajes de error relacionados con la autenticación.
  String? _errorMessage;

  /// Navega a la pantalla principal de la aplicación.
  void _navigateToHome() {
    AppNavigator.pushReplacementNamed(
      context,
      AppRoute.home,
      transition: PageTransition.fade, // Transición de desvanecimiento.
    );
  }

  /// Navega a la pantalla de registro.
  void _navigateToRegister() {
    AppNavigator.pushNamed(
      context,
      AppRoute.register,
      transition: PageTransition.slide, // Transición de desplazamiento.
    );
  }

  /// Maneja el inicio de sesión con Google.
  ///
  /// Muestra un indicador de carga mientras realiza la autenticación.
  /// En caso de éxito, navega a la pantalla principal.
  /// Si ocurre un error, muestra un mensaje en pantalla.
  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true); // Activa el indicador de carga.
    try {
      await _authManager.signInWithGoogle(true); // Autenticación con Google.
      _navigateToHome(); // Navega a la pantalla principal.
    } catch (e) {
      // Captura errores y muestra un mensaje descriptivo.
      setState(() => _errorMessage = ErrorHandler.getAuthErrorMessage(e));
    } finally {
      setState(() => _isLoading = false); // Desactiva el indicador de carga.
    }
  }

  /// Maneja el inicio de sesión con correo electrónico y contraseña.
  ///
  /// [email]: Correo electrónico del usuario.
  /// [password]: Contraseña del usuario.
  ///
  /// Similar a `_handleGoogleSignIn`, muestra un indicador de carga,
  /// maneja errores y navega a la pantalla principal en caso de éxito.
  void _handleEmailSignIn(String email, String password) async {
    setState(() => _isLoading = true); // Activa el indicador de carga.
    try {
      await _authManager.signInWithEmail(email, password); // Autenticación con correo.
      _navigateToHome(); // Navega a la pantalla principal.
    } catch (e) {
      // Captura errores y muestra un mensaje descriptivo.
      setState(() => _errorMessage = ErrorHandler.getAuthErrorMessage(e));
    } finally {
      setState(() => _isLoading = false); // Desactiva el indicador de carga.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login.title'.tr()), // Título traducido.
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Indicador de carga.
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Formulario de inicio de sesión con correo y contraseña.
                  EmailPasswordForm(onSubmit: _handleEmailSignIn),
                  
                  // Botón para inicio de sesión con Google.
                  ElevatedButton(
                    onPressed: _handleGoogleSignIn,
                    child: Text('login.google_sign_in'.tr()), // Texto traducido.
                  ),
                  
                  // Botón para navegar a la pantalla de registro.
                  TextButton(
                    onPressed: _navigateToRegister,
                    child: Text('login.register'.tr()), // Texto traducido.
                  ),
                  
                  // Mensaje de error en caso de que exista.
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red), // Estilo de texto en rojo.
                    ),
                ],
              ),
      ),
    );
  }
}
