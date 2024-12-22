class FileValidator {
  static const int maxFileSize = 40 * 1024 * 1024; // 40MB en bytes

  static String? validatePdfFile(String name, String mime, int size) {
    if (!name.toLowerCase().endsWith('.pdf')) 
    {
      return 'El archivo debe ser un PDF.';
    }
    if (mime != 'application/pdf') {
      return 'El tipo de archivo no es válido. Debe ser un PDF.';
    }
    if (size > maxFileSize) {
      return 'El archivo es demasiado grande. El tamaño máximo es 40MB.';
    }
    return null; // Null significa que no hay errores
  }
}
