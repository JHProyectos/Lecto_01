import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import '../../shared/utils/audio_player.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/language_selector.dart';
import '../../core/theme/theme_config.dart';

/// Pantalla para la reproducción de audio generado a partir de PDF
class PlaybackScreen extends StatefulWidget {
  final String fileName;

  const PlaybackScreen({Key? key, required this.fileName}) : super(key: key);

  @override
  _PlaybackScreenState createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  bool _isPlaying = false;
  double _progress = 0.0;
  late StreamSubscription<double> _playerSubscription;

  @override
  void dispose() {
    _playerSubscription.cancel();
    super.dispose();
  }

  /// Inicia o pausa la reproducción del audio
  void _togglePlayback() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _playerSubscription = AudioPlayer.playAudio(widget.fileName).listen(
        (progress) {
          setState(() {
            _progress = progress;
          });
        },
        onDone: () {
          setState(() {
            _isPlaying = false;
            _progress = 0.0;
          });
        },
      );
    } else {
      _playerSubscription.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('playback.title'.tr()),
        actions: [
          const LanguageSelector(),
          ThemeConfig.buildThemeToggleButton(context),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Muestra el nombre del archivo de audio
            Text(
              'playback.file'.tr(args: [widget.fileName]),
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32.0),
            // Barra de progreso de la reproducción
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 16.0),
            // Tiempo de reproducción
            Text(
              'playback.progress_percentage'.tr(args: [(_progress * 100).toStringAsFixed(0)]),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 32.0),
            // Botones de control de reproducción
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  onPressed: _togglePlayback,
                  child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 16.0),
                CustomButton(
                  onPressed: () {
                    setState(() {
                      _progress = 0.0;
                      _isPlaying = false;
                    });
                    _playerSubscription.cancel();
                  },
                  child: const Icon(Icons.stop),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
