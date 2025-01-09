import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Widget para reproducir audio con opciones de control.
/// Permite reproducir, pausar, cambiar la velocidad de reproducción (si es premium)
/// y mostrar la posición y duración del audio.
class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl; // URL del audio a reproducir.
  final Duration? initialPosition; // Posición inicial opcional para empezar el audio.
  final bool isPremium; // Indica si el usuario tiene acceso a funciones premium.

  const AudioPlayerWidget({
    Key? key,
    required this.audioUrl,
    this.initialPosition,
    required this.isPremium,
  }) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer; // Controlador del reproductor de audio.
  bool _isPlaying = false; // Estado actual de reproducción.
  Duration _duration = Duration.zero; // Duración total del audio.
  Duration _position = Duration.zero; // Posición actual del audio.
  double _playbackRate = 1.0; // Velocidad de reproducción actual.

  @override
  void initState() {
    super.initState();
    _initAudioPlayer(); // Inicializa el reproductor de audio.
  }

  /// Inicializa el reproductor de audio y configura los escuchadores para duración, posición y finalización.
  void _initAudioPlayer() async {
    _audioPlayer = AudioPlayer();

    // Configura la fuente del audio a reproducir.
    await _audioPlayer.setSourceUrl(widget.audioUrl);

    // Si se especifica una posición inicial, comienza desde ahí.
    if (widget.initialPosition != null) {
      await _audioPlayer.seek(widget.initialPosition!);
    }

    // Escucha cambios en la duración del audio.
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    // Escucha cambios en la posición actual del audio.
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });

    // Cuando el audio termina, reinicia el estado.
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero;
      });
    });
  }

  /// Reproduce el audio.
  Future<void> play() async {
    await _audioPlayer.resume();
    setState(() {
      _isPlaying = true;
    });
  }

  /// Pausa el audio.
  Future<void> pause() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  /// Cambia la posición del audio.
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Cambia la velocidad de reproducción si el usuario es premium.
  Future<void> setPlaybackRate(double rate) async {
    if (widget.isPremium) {
      await _audioPlayer.setPlaybackRate(rate);
      setState(() {
        _playbackRate = rate;
      });
    } else {
      // Muestra un diálogo informando que es una función premium.
      _showPremiumDialog();
    }
  }

  /// Muestra un diálogo para indicar que la función es premium.
  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Función Premium'),
          content: Text(
              'El cambio de velocidad de reproducción es una función premium. ¿Deseas actualizar tu suscripción?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Actualizar'),
              onPressed: () {
                // Aquí iría la lógica para actualizar a premium.
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
    return Column(
      children: [
        // Slider para mostrar y controlar la posición del audio.
        Slider(
          min: 0,
          max: _duration.inSeconds.toDouble(),
          value: _position.inSeconds.toDouble(),
          onChanged: (value) {
            final position = Duration(seconds: value.toInt());
            seek(position);
          },
        ),
        // Muestra la posición actual y el tiempo restante del audio.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(_position)), // Posición actual.
              Text(_formatDuration(_duration - _position)), // Tiempo restante.
            ],
          ),
        ),
        // Controles de reproducción y velocidad.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón de reproducción o pausa.
            IconButton(
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: _isPlaying ? pause : play,
            ),
            // Menú para seleccionar la velocidad de reproducción.
            PopupMenuButton<double>(
              child: Chip(
                label: Text('${_playbackRate}x'),
              ),
              onSelected: setPlaybackRate,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<double>>[
                PopupMenuItem<double>(
                  value: 0.75,
                  child: Text('0.75x'),
                ),
                PopupMenuItem<double>(
                  value: 1.0,
                  child: Text('1.0x'),
                ),
                PopupMenuItem<double>(
                  value: 1.25,
                  child: Text('1.25x'),
                ),
                PopupMenuItem<double>(
                  value: 1.5,
                  child: Text('1.5x'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Formatea la duración en un formato legible (hh:mm:ss).
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Libera recursos del reproductor de audio.
    super.dispose();
  }
}
