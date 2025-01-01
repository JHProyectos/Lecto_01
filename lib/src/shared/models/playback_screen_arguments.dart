//lib/src/shared/models/playback_screen_arguments.dart
/// Modelo de argumentos para la pantalla de reproducción (`PlaybackScreen`).
/// 
/// Este modelo encapsula los datos necesarios para inicializar la pantalla de reproducción,
/// como el nombre del archivo y, opcionalmente, una posición inicial de reproducción.
class PlaybackScreenArguments {
  /// Nombre del archivo que se reproducirá.
  final String fileName;

  /// Posición inicial para comenzar la reproducción (opcional).
  /// Si se proporciona, debe ser una duración no negativa.
  final Duration? initialPosition;

  /// Constructor para crear los argumentos de la pantalla de reproducción.
  /// 
  /// [fileName]: Nombre del archivo que se reproducirá (obligatorio).
  /// [initialPosition]: Posición inicial para comenzar la reproducción (opcional).
  /// 
  /// Lanza una [ArgumentError] si [fileName] es una cadena vacía o si [initialPosition] es negativo.
  PlaybackScreenArguments({
    required this.fileName,
    this.initialPosition,
  }) {
    if (fileName.isEmpty) {
      throw ArgumentError('El nombre del archivo no puede estar vacío.');
    }
    if (initialPosition != null && initialPosition!.isNegative) {
      throw ArgumentError('La posición inicial no puede ser negativa.');
    }
  }

  /// Convierte el modelo a un mapa JSON.
  /// 
  /// Este método es útil para la serialización, por ejemplo, al pasar argumentos
  /// entre rutas o al enviar datos a una API.
  /// 
  /// Retorna un [Map] con las claves 'fileName' y 'initialPosition'.
  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'initialPosition': initialPosition?.inSeconds,
      };

  /// Crea un modelo a partir de un mapa JSON.
  /// 
  /// Este método es útil para la deserialización, por ejemplo, al recibir argumentos
  /// de una ruta o al procesar datos de una API.
  /// 
  /// [json]: Un mapa que contiene los datos para crear el objeto.
  /// 
  /// Retorna una nueva instancia de [PlaybackScreenArguments].
  factory PlaybackScreenArguments.fromJson(Map<String, dynamic> json) {
    return PlaybackScreenArguments(
      fileName: json['fileName'] as String,
      initialPosition: json['initialPosition'] != null
          ? Duration(seconds: json['initialPosition'] as int)
          : null,
    );
  }

  @override
  String toString() {
    return 'PlaybackScreenArguments(fileName: $fileName, initialPosition: $initialPosition)';
  }

  /// Compara este objeto con otro para determinar si son iguales.
  /// 
  /// Dos [PlaybackScreenArguments] se consideran iguales si tienen el mismo
  /// [fileName] y [initialPosition].
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaybackScreenArguments &&
          runtimeType == other.runtimeType &&
          fileName == other.fileName &&
          initialPosition == other.initialPosition;

  /// Genera un código hash para este objeto.
  /// 
  /// El código hash se basa en los valores de [fileName] y [initialPosition].
  @override
  int get hashCode => fileName.hashCode ^ initialPosition.hashCode;
}
