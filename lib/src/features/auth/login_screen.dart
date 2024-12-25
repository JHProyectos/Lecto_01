//lib/source/features/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/auth/authentication_manager.dart';
import '../../core/error/error_handler.dart';
import '../../core/validation/form_validation_service.dart';
import '../../shared/layouts/login_screen_layout.dart';
import '../../shared/widgets/language_selector.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_route.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authManager = AuthenticationManager();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      await _authManager.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
        true, // Assuming UTN student flag
      );
      AppNavigator.pushReplacementRoute(
        page: const HomeScreen(),
        settings: RouteSettings(name: AppRoute.home.path),
      );
    } catch (e) {
      setState(() => _errorMessage = ErrorHandler.getAuthErrorMessage(e));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await _authManager.signInWithGoogle(true);
      AppNavigator.pushReplacementRoute(
        page: const HomeScreen(),
        settings: RouteSettings(name: AppRoute.home.path),
      );
    } catch (e) {
      setState(() => _errorMessage = ErrorHandler.getAuthErrorMessage(e));
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text('login.title'.tr()),
        actions: const [
          LanguageSelector(),
        ],
      ),
      body: Stack(
        children: [
          LoginScreenLayout.buildResponsiveLayout(
            isPortrait: isPortrait,
            contentBuilder: (spacing, logoWidth) => Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'login.email'.tr(),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'login.password'.tr(),
                  ),
                ),
                if (_errorMessage != null)
                  Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: Text('login.login_button'.tr()),
                ),
                ElevatedButton(
                  onPressed: _handleGoogleSignIn,
                  child: Text('login.google_login'.tr()),
                ),
              ],
            ),
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
