// Widgets y funcionalidades básicas de Flutter
import 'package:flutter/material.dart';

// Localización
import 'package:easy_localization/easy_localization.dart';

// Navegación y rutas
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_route.dart';
import '../../core/navigation/page_transition.dart';

// Gestión de temas
import '../../core/providers/theme_provider.dart';
import '../../core/theme/theme_config.dart';

// Utilidades y widgets personalizados
import '../../shared/utils/file_processor.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/language_selector.dart';

// Otras pantallas (para navegación)
import '../playback/playback_screen.dart';

/// Pantalla que muestra el progreso del procesamiento de PDF a audio
/// Estado de la pantalla de procesamiento (Processing).
class _ProcessingScreenState extends State<ProcessingScreen> {
  /// Indica si el archivo está siendo procesado.
  bool _isProcessing = true;

  /// Progreso actual del procesamiento, expresado como un valor entre 0.0 y 1.0.
  double _progress = 0.0;

  /// Navega a la pantalla de reproducción (Playback) cuando el procesamiento finaliza.
  void _navigateToPlayback() {
    AppNavigator.pushReplacementNamed(
      context,
      AppRoute.playback,
      arguments: PlaybackScreenArguments(fileName: widget.fileName), // Argumentos necesarios para la reproducción.
      transition: PageTransition.fade, // Transición de desvanecimiento.
    );
  }

  @override
  void initState() {
    super.initState();
    _startProcessing(); // Inicia el procesamiento del archivo al cargar la pantalla.
  }

  /// Inicia la lógica de procesamiento del archivo.
  ///
  /// Se actualiza el progreso en tiempo real y, al finalizar,
  /// navega automáticamente a la pantalla de reproducción.
  void _startProcessing() async {
    try {
      // Simula la operación de procesamiento mediante un flujo (stream).
      await for (final progress in processFile(widget.fileName)) {
        setState(() => _progress = progress); // Actualiza el progreso en la interfaz.
      }
      _navigateToPlayback(); // Navega a la pantalla de reproducción al terminar.
    } catch (e) {
      // Maneja errores durante el procesamiento (opcional: mostrar un mensaje de error).
    } finally {
      setState(() => _isProcessing = false); // Marca el fin del estado de procesamiento.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('processing.title'.tr()), // Título traducido dinámicamente.
      ),
      body: Center(
        // Muestra un indicador de progreso mientras el archivo está en proceso.
        child: _isProcessing
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Indicador de progreso circular con el valor actual.
                CircularProgressIndicator(value: _progress),
                // Texto que muestra el porcentaje completado.
                Text('${(_progress * 100).toStringAsFixed(0)}%'),
              ],
            )
          : ElevatedButton(
              // Botón para navegar a la pantalla de reproducción una vez terminado.
              onPressed: _navigateToPlayback,
              child: Text('processing.view_result'.tr()), // Texto traducido.
            ),
      ),
    );
  }
}
