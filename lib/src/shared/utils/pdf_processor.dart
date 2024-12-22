import 'dart:async';

/// Clase para manejar el procesamiento de PDF a audio
class PdfProcessor {
  /// Simula el procesamiento de un archivo PDF
  /// 
  /// [fileName] es el nombre del archivo PDF a procesar
  /// Retorna un [Stream] que emite el progreso del procesamiento
  static Stream<double> processPdf(String fileName) async* {
    for (var i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      yield i / 100;
    }
  }
}
