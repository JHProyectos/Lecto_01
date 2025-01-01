// Widgets y funcionalidades básicas de Flutter
import 'package:flutter/material.dart';

// Localización
import 'package:easy_localization/easy_localization.dart';

// Navegación y rutas
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_route.dart';

// Gestión de temas
import '../../core/providers/theme_provider.dart';
import '../../core/theme/theme_config.dart';

// Widgets personalizados
import '../../shared/widgets/audio_player.dart';
import '../../shared/widgets/language_selector.dart';

// Modelos y argumentos
import '../../shared/models/playback_screen_arguments.dart';

/// Pantalla para la reproducción de audio generado a partir de PDF
/// Estado de la pantalla de reproducción (Playback).
///
/// Esta pantalla permite la visualización de un archivo previamente procesado.
/// Además, gestiona cambios no guardados y muestra un diálogo de confirmación
/// antes de descartar dichos cambios al navegar hacia atrás.
class _PlaybackScreenState extends State<PlaybackScreen> {
  /// Indica si hay cambios no guardados en la pantalla.
  bool _hasUnsavedChanges = false;

  /// Maneja la acción de regresar (back).
  ///
  /// Si hay cambios no guardados, se muestra un diálogo de confirmación
  /// para decidir si se descartan los cambios. Si no hay cambios o el usuario
  /// elige descartarlos, se cierra la pantalla.
  void _handleBack() async {
    if (_hasUnsavedChanges) {
      final shouldDiscard = await _showDiscardDialog(); // Muestra el diálogo de confirmación.
      if (shouldDiscard) {
        AppNavigator.pop(context); // Regresa a la pantalla anterior si el usuario elige descartar.
      }
      return; // Detiene la ejecución si el usuario no descarta los cambios.
    }
    AppNavigator.pop(context); // Regresa directamente si no hay cambios.
  }

  /// Muestra un diálogo de confirmación para descartar cambios no guardados.
  ///
  /// Devuelve `true` si el usuario confirma descartar los cambios,
  /// o `false` si cancela la acción.
  Future<bool> _showDiscardDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('playback.discard_changes_title'.tr()), // Título traducido.
        content: Text('playback.discard_changes_message'.tr()), // Mensaje traducido.
        actions: [
          // Botón para cancelar y mantener los cambios.
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('common.cancel'.tr()), // Texto traducido para cancelar.
          ),
          // Botón para confirmar el descarte de los cambios.
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('common.discard'.tr()), // Texto traducido para descartar.
          ),
        ],
      ),
    ) ?? false; // Devuelve `false` si el diálogo se cierra sin respuesta.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('playback.title'.tr()), // Título dinámico traducido.
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícono de navegación hacia atrás.
          onPressed: _handleBack, // Llama al manejador de acción de regreso.
        ),
      ),
      body: Center(
        child: Text('Reproduciendo: ${widget.fileName}'), // Muestra el archivo actual.
      ),
    );
  }
}
