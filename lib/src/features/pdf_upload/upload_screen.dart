// Widgets y funcionalidades básicas de Flutter
import 'package:flutter/material.dart';
import 'dart:io';

// Localización
import 'package:easy_localization/easy_localization.dart';

// Navegación y rutas
import '../../core/navigation/app_navigator.dart';
import '../../core/navigation/app_route.dart';
import '../../core/navigation/page_transition.dart';

// Manejo de errores
import '../../core/error/error_handler.dart';

// Gestión de temas
import '../../core/providers/theme_provider.dart';
import '../../core/theme/theme_config.dart';

// Utilidades y widgets personalizados
import '../../shared/utils/file_uploader.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/language_selector.dart';

// Otras pantallas (para navegación)
import '../processing/processing_screen.dart';

/// Pantalla para subir archivos PDF
/// Estado de la pantalla de carga (Upload).
class _UploadScreenState extends State<UploadScreen> {
  /// Indica si se está realizando una operación de carga.
  bool _isUploading = false;

  /// Mensaje de error, en caso de que ocurra un problema durante la carga.
  String? _errorMessage;

  /// Navega a la pantalla de procesamiento después de cargar un archivo.
  ///
  /// [fileName]: Nombre del archivo cargado.
  void _navigateToProcessing(String fileName) {
    AppNavigator.pushNamed(
      context,
      AppRoute.processing,
      arguments: ProcessingScreenArguments(fileName: fileName), // Argumentos de procesamiento.
      transition: PageTransition.slide, // Transición de desplazamiento.
    );
  }

  /// Maneja la lógica para cargar un archivo.
  ///
  /// [file]: Archivo que se desea cargar.
  /// Una vez cargado, redirige a la pantalla de procesamiento.
  void _handleUpload(File file) async {
    setState(() => _isUploading = true); // Indica que el estado es "subiendo".
    try {
      final fileName = await uploadFile(file); // Simula la operación de carga del archivo.
      _navigateToProcessing(fileName); // Navega a la pantalla de procesamiento.
    } catch (e) {
      // Captura errores y los asigna al mensaje de error.
      setState(() => _errorMessage = ErrorHandler.getUploadErrorMessage(e));
    } finally {
      setState(() => _isUploading = false); // Finaliza el estado de "subiendo".
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('upload.title'.tr())), // Título traducido.
      body: Center(
        // Muestra un indicador de carga o el contenido principal.
        child: _isUploading
          ? CircularProgressIndicator() // Indicador de carga mientras se realiza la operación.
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón para cargar un archivo.
                ElevatedButton(
                  onPressed: () => _handleUpload(File('path/to/file')), // Simula la selección de un archivo.
                  child: Text('upload.select_file'.tr()), // Texto traducido.
                ),
                // Muestra un mensaje de error si ocurre un problema durante la carga.
                if (_errorMessage != null)
                  Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              ],
            ),
      ),
    );
  }
}
