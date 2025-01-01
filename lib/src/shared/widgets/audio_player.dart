import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// Widget personalizado para la reproducción de audio
class AudioPlayerWidget extends StatefulWidget {
  // URL del archivo de audio a reproducir
  final String audioUrl;

  // Constructor del widget
  const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  // Instancia del reproductor de audio
  late AudioPlayer _audioPlayer;
  
  // Estado de la reproducción (si está en reproducción o en pausa)
  bool _isPlaying = false;
  
  // Duración total del audio
  Duration _duration = Duration.zero;
  
  // Posición actual del audio
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Inicializa el reproductor de audio
    _setupAudioPlayer(); // Configura los oyentes de duración y posición
  }

  // Configura los oyentes del reproductor de audio
  void _setupAudioPlayer() {
    // Escucha cambios en la duración del audio
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration; // Actualiza la duración
      });
    });

    // Escucha cambios en la posición del audio
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition; // Actualiza la posición
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Control deslizante para cambiar la posición del audio
        Slider(
          min: 0,
          max: _duration.inSeconds.toDouble(),
          value: _position.inSeconds.toDouble(),
          onChanged: (value) {
            final position = Duration(seconds: value.toInt()); // Calcula la nueva posición
            _audioPlayer.seek(position); // Reposiciona el audio
          },
        ),
        // Muestra el tiempo transcurrido y el tiempo restante del audio
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Muestra el tiempo transcurrido
              Text(formatTime(_position)),
              // Muestra el tiempo restante
              Text(formatTime(_duration - _position)),
            ],
          ),
        ),
        // Botón para reproducir o pausar el audio
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () async {
            // Si el audio está en reproducción, lo pausa; si está en pausa, lo reproduce
            if (_isPlaying) {
              await _audioPlayer.pause(); // Pausa el audio
            } else {
              await _audioPlayer.play(UrlSource(widget.audioUrl)); // Reproduce el audio desde la URL
            }
            setState(() {
              _isPlaying = !_isPlaying; // Cambia el estado de reproducción
            });
          },
        ),
      ],
    );
  }

  // Formatea la duración a un formato de horas, minutos y segundos (HH:mm:ss)
  String formatTime(Duration duration) {
    // Función para añadir ceros a la izquierda en los números
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    
    // Obtiene los minutos y segundos, formateados con dos dígitos
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    
    // Devuelve el formato de tiempo completo
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libera el reproductor de audio cuando el widget es destruido
    super.dispose();
  }
}
