import 'dart:async';

/// Clase para manejar la reproducción de audio
class AudioPlayer {
  /// Simula la reproducción de un archivo de audio
  /// 
  /// [fileName] es el nombre del archivo de audio a reproducir
  /// Retorna un [Stream] que emite el progreso de la reproducción
  static Stream<double> playAudio(String fileName) async* {
    for (var i = 0; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 100));
      yield i / 100;
    }
  }
}
