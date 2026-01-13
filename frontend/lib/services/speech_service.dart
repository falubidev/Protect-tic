import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  Future<bool> initialize() async {
    _isInitialized = await _speech.initialize(
      onStatus: (status) {},
      onError: (error) {},
    );
    return _isInitialized;
  }

  bool get isListening => _speech.isListening;

  Future<void> startListening(Function(String) onResult) async {
    if (!_isInitialized) await initialize();
    if (!_isInitialized) {
      return;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            final spokenText = result.recognizedWords;
            onResult(spokenText);
          }
        },
        listenOptions: stt.SpeechListenOptions(
          partialResults: false,
          listenMode: stt.ListenMode.confirmation,
        ),
        localeId: 'es-ES',
      );
    } catch (e) {
      throw Exception('Error al iniciar el reconocimiento de voz');
    }
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }

  Future<void> cancel() async {
    await _speech.cancel();
  }
}