import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/tts_service.dart';
import '../services/speech_service.dart';

class AudioVoiceControls extends StatefulWidget {
  final Function(String)? onVoiceCommand;
  final String? audioText;

  const AudioVoiceControls({super.key, this.onVoiceCommand, this.audioText});

  @override
  State<AudioVoiceControls> createState() => _AudioVoiceControlsState();
}

class _AudioVoiceControlsState extends State<AudioVoiceControls> {
  final TtsService _ttsService = TtsService();
  final SpeechService _speechService = SpeechService();
  bool _isListening = false;
  bool _isFirstAudioPress = true;

  Future<void> _handleMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      if (!result.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permiso de micrófono denegado')),
        );
        return;
      }
    }
  }

  Future<void> _toggleListening() async {
    await _handleMicrophonePermission();

    if (!_isListening) {
      final available = await _speechService.initialize();
      if (!available) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo iniciar el reconocimiento')),
        );
        await _ttsService.speak('No se pudo iniciar el reconocimiento de voz');
        return;
      }

      setState(() => _isListening = true);
      await _speechService.startListening((command) {
        widget.onVoiceCommand?.call(command);
      });
    } else {
      await _stopListening();
    }
  }

  Future<void> _stopListening() async {
    await _speechService.stopListening();
    setState(() => _isListening = false);
  }

  Future<void> _speakAudio() async {
    if (_isFirstAudioPress &&
        (widget.audioText == null || widget.audioText!.isEmpty)) {
      await _ttsService.speak(
        'Bienvenido. Usa los siguientes comandos de voz: '
        'Di "país" seguido del nombre del país, por ejemplo, "país México". '
        'Di "categoría" seguido de bancos, telefonía o entidades, por ejemplo, "categoría bancos". '
        'Di "buscar" seguido del nombre a buscar, por ejemplo, "buscar Banco Azteca". '
        'Di "seleccionar" seguido del nombre de la entidad, por ejemplo, "seleccionar Banco Azteca". '
        'Di "leer" para escuchar la información de la entidad seleccionada.'
        'Di "instrucciones" para escuchar los comandos de voz nuevamente.',
      );
      setState(() => _isFirstAudioPress = false);
    } else if (widget.audioText != null && widget.audioText!.isNotEmpty) {
      await _ttsService.speak(widget.audioText!);
    } else {
      await _ttsService.speak(
        'No hay texto para leer. Selecciona una entidad primero. '
        'Di "instrucciones" para escuchar los comandos de voz nuevamente.',
      );
    }
  }

  @override
  void dispose() {
    _speechService.cancel();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 48,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        children: [
          _buildButton(
            icon: _isListening ? Icons.stop : Icons.mic,
            label: 'Voz',
            onPressed: _toggleListening,
          ),
          _buildButton(
            icon: Icons.volume_up,
            label: 'Audio',
            onPressed: _speakAudio,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFFC2A88F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.black, size: 36),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}