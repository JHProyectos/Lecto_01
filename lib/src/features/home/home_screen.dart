import 'package:flutter/material.dart';
import '../../shared/layouts/orientation_layout.dart';
import '../../shared/styles/orientation_styles.dart';
import '../../core/auth/authentication_manager.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/app_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../shared/widgets/language_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthenticationManager _authManager = AuthenticationManager();
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Carga los datos del usuario actual
  Future<void> _loadUserData() async {
    final user = await _authManager.getCurrentUser();
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? 'user.default_name'.tr();
      });
    }
  }

  // Maneja el proceso de cierre de sesión
  Future<void> _handleLogout() async {
    await _authManager.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home.title'.tr()),
        actions: [
          const LanguageSelector(), // Selector de idioma
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'home.logout'.tr(),
          ),
        ],
      ),
      body: OrientationLayout(
        portraitLayout: (context) => _buildLayout(context, isPortrait: true),
        landscapeLayout: (context) => _buildLayout(context, isPortrait: false),
      ),
    );
  }

  // Construye el diseño principal basado en la orientación
  Widget _buildLayout(BuildContext context, {required bool isPortrait}) {
    final padding = isPortrait
        ? OrientationStyles.portraitPadding
        : OrientationStyles.landscapePadding;
    final spacing = isPortrait
        ? OrientationStyles.portraitSpacing
        : OrientationStyles.landscapeSpacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWelcomeSection(spacing),
          SizedBox(height: spacing),
          _buildFeatureButtons(spacing),
        ],
      ),
    );
  }

  // Construye la sección de bienvenida
  Widget _buildWelcomeSection(double spacing) {
    return Column(
      children: [
        AppLogo(size: 120.0), // Logo de la app
        SizedBox(height: spacing),
        Text(
          'home.welcome'.tr(args: [_userName]),
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: spacing / 2),
        Text(
          'home.what_to_do'.tr(),
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    );
  }

  // Construye los botones de características principales
  Widget _buildFeatureButtons(double spacing) {
    return Column(
      children: [
        CustomButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/pdf_upload');
          },
          child: Text('home.upload_pdf'.tr()),
        ),
        SizedBox(height: spacing),
        CustomButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/text_to_speech');
          },
          child: Text('home.text_to_speech'.tr()),
        ),
        SizedBox(height: spacing),
        CustomButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/audio_playback');
          },
          child: Text('home.my_audio_files'.tr()),
        ),
      ],
    );
  }
}
