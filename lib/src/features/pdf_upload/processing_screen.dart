import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../shared/utils/pdf_processor.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/language_selector.dart';
import '../../core/theme/theme_config.dart';
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_route.dart';

/// Pantalla que muestra el progreso del procesamiento de PDF a audio
class ProcessingScreen extends StatefulWidget {
  final String fileName;

  const ProcessingScreen({Key? key, required this.fileName}) : super(key: key);

  @override
  _ProcessingScreenState createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  double _progress = 0.0;
  bool _isProcessing = true;

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  /// Inicia el procesamiento del PDF
  void _startProcessing() {
    PdfProcessor.processPdf(widget.fileName).listen(
      (progress) {
        setState(() {
          _progress = progress;
        });
      },
      onDone: () {
        setState(() {
          _isProcessing = false;
        });
      },
    );
  }

  /// Navega a la pantalla de reproducción
  void _navigateToPlayback() {
    AppNavigator.pushReplacementRoute(
      page: PlaybackScreen(fileName: widget.fileName),
      settings: RouteSettings(name: AppRoute.playback.path),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('processing.title'.tr()),
        actions: [
          const LanguageSelector(),
          ThemeConfig.buildThemeToggleButton(context),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Muestra el nombre del archivo que se está procesando
              Text(
                'processing.processing_file'.tr(args: [widget.fileName]),
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              // Barra de progreso
              LinearProgressIndicator(value: _progress),
              const SizedBox(height: 16.0),
              // Porcentaje de progreso
              Text(
                'processing.progress_percentage'.tr(args: [(_progress * 100).toStringAsFixed(0)]),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(height: 32.0),
              // Botón para ir a la pantalla de reproducción
              if (!_isProcessing)
                CustomButton(
                  onPressed: _navigateToPlayback,
                  child: Text('processing.go_to_playback'.tr()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
