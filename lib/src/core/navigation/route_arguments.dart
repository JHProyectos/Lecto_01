/// Clase base para argumentos de ruta
abstract class RouteArguments {}

/// Argumentos para la pantalla de procesamiento
class ProcessingScreenArguments extends RouteArguments {
  final String fileName;
  final int fileSize;
  final String mimeType;

  ProcessingScreenArguments({
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
  });
}

/// Argumentos para la pantalla de reproducción
class PlaybackScreenArguments extends RouteArguments {
  final String audioFile;
  final Duration duration;
  final String originalFileName;

  PlaybackScreenArguments({
    required this.audioFile,
    required this.duration,
    required this.originalFileName,
  });
}
/*
/// Argumentos tipados para las rutas
abstract class RouteArguments {}

class ProcessingArguments extends RouteArguments {
  final String fileName;
  final int fileSize;

  ProcessingArguments({required this.fileName, required this.fileSize});
}

class PlaybackArguments extends RouteArguments {
  final String audioFile;
  final Duration duration;

  PlaybackArguments({required this.audioFile, required this.duration});
}
*/
