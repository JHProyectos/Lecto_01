/// Clase base para argumentos de ruta, que incluye métodos de serialización.
abstract class RouteArguments {
  /// Convierte los argumentos en un mapa para serialización.
  Map<String, dynamic> toMap();
}

/// Argumentos para la pantalla de reproducción.
class PlaybackScreenArguments implements RouteArguments {
  /// Nombre del archivo a reproducir.
  final String fileName;

  /// Posición inicial desde donde se comenzará la reproducción.
  final Duration initialPosition;

  /// Constructor para inicializar los argumentos.
  PlaybackScreenArguments({
    required this.fileName,
    this.initialPosition = Duration.zero,
  });

  /// Convierte los argumentos en un mapa para su serialización.
  @override
  Map<String, dynamic> toMap() => {
        'fileName': fileName,
        'initialPosition': initialPosition.inMilliseconds,
      };

  /// Construye los argumentos desde un mapa.
  factory PlaybackScreenArguments.fromMap(Map<String, dynamic> map) {
    return PlaybackScreenArguments(
      fileName: map['fileName'] as String,
      initialPosition: Duration(milliseconds: map['initialPosition'] as int),
    );
  }
}
