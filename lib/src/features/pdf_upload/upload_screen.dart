import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/app_logo.dart';
import '../../shared/utils/file_validator.dart';
import '../../shared/widgets/language_selector.dart';

/// Pantalla para subir archivos PDF
class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  // Controlador para la zona de arrastre de archivos
  late DropzoneViewController _dropzoneController;
  
  // Nombre del archivo seleccionado
  String? _selectedFileName;
  
  // Indica si se está cargando un archivo
  bool _isUploading = false;
  
  // Mensaje de error, si lo hay
  String? _errorMessage;

  /// Inicializa el controlador de la zona de arrastre
  void _onDropzoneLoaded(DropzoneViewController controller) {
    _dropzoneController = controller;
  }

  /// Maneja el evento de soltar un archivo en la zona de arrastre
  Future<void> _onFileDropped(dynamic event) async {
    final name = event.name;
    final mime = await _dropzoneController.getFileMIME(event);
    final size = await _dropzoneController.getFileSize(event);
    
    // Valida el archivo usando FileValidator
    final errorMessage = FileValidator.validatePdfFile(name, mime, size);

    setState(() {
      if (errorMessage == null) {
        _selectedFileName = name;
        _errorMessage = null;
      } else {
        _errorMessage = errorMessage;
        _selectedFileName = null;
      }
    });
  }

  /// Abre el selector de archivos y maneja la selección
  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      final file = result.files.first;
      // Valida el archivo seleccionado
      final errorMessage = FileValidator.validatePdfFile(
        file.name, 
        file.extension ?? '', 
        file.size
      );

      setState(() {
        if (errorMessage == null) {
          _selectedFileName = file.name;
          _errorMessage = null;
        } else {
          _errorMessage = errorMessage;
          _selectedFileName = null;
        }
      });
    }
  }

  /// Simula la carga del archivo seleccionado
  Future<void> _uploadFile() async {
    if (_selectedFileName == null) return;

    setState(() {
      _isUploading = true;
    });

    // Aquí iría la lógica real de carga del archivo
    // Por ahora, solo simulamos una espera de 2 segundos
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isUploading = false;
      _selectedFileName = null;
    });

    _showUploadSuccessDialog();
  }

  /// Muestra un diálogo de éxito después de la carga
  void _showUploadSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('upload.success_title'.tr()),
          content: Text('upload.success_message'.tr()),
          actions: <Widget>[
            TextButton(
              child: Text('common.ok'.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload.title'.tr()),
        actions: const [
          LanguageSelector(),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo de la aplicación
              const AppLogo(size: 100.0),
              const SizedBox(height: 32.0),

              // Zona de arrastre para soltar archivos
              DropzoneView(
                onCreated: _onDropzoneLoaded,
                onDrop: _onFileDropped,
                operation: DragOperation.copy,
                cursor: CursorType.grab,
                child: Container(
                  height: 150.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      _selectedFileName ?? 'upload.drag_file_here'.tr(),
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              
              // Muestra el mensaje de error si existe
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16.0),

              // Botón para seleccionar archivo manualmente
              CustomButton(
                onPressed: _selectFile,
                child: Text('upload.select_pdf'.tr()),
              ),
              const SizedBox(height: 16.0),

              // Botón para subir el archivo seleccionado
              CustomButton(
                onPressed: _selectedFileName != null && !_isUploading
                    ? _uploadFile
                    : null,
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : Text('upload.upload_pdf'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
