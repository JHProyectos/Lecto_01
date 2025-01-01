//lib/src/shared/utils/file_processor.dart

class FileProcessor {
  /// Procesa un archivo PDF de manera remota utilizando Firebase Cloud Functions.
  ///
  /// [fileName]: El nombre del archivo que se desea procesar.
  ///
  /// Retorna un `Stream<double>` que emite el progreso del procesamiento del archivo,
  /// donde el valor oscila entre 0.0 (inicio) y 1.0 (completado).
  ///
  /// Lanza excepciones si ocurre algún problema durante el procesamiento.
  static Stream<double> processFile(String fileName) async* {
    // Llama a la función remota 'processPdf' para iniciar el procesamiento.
    final callable = FirebaseFunctions.instance.httpsCallable('processPdf');
    final result = await callable.call<Map<String, dynamic>>({'fileName': fileName});
    
    // Obtiene el identificador de la tarea desde el resultado.
    final taskId = result.data['taskId'] as String;
    double progress = 0;
    
    // Monitorea el progreso hasta que se complete.
    while (progress < 1) {
      // Espera 1 segundo antes de consultar el estado nuevamente.
      await Future.delayed(const Duration(seconds: 1));
      
      // Llama a la función remota 'getProcessingStatus' para obtener el progreso.
      final statusResult = await FirebaseFunctions.instance
          .httpsCallable('getProcessingStatus')
          .call<Map<String, dynamic>>({'taskId': taskId});
      
      // Actualiza el progreso con el valor recibido.
      progress = statusResult.data['progress'] as double;
      
      // Emite el valor de progreso actual.
      yield progress;
    }
  }
}

