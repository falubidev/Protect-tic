import 'package:flutter/material.dart';
import 'package:protectic/screens/recover_pin/success_dialog.dart';
import 'package:protectic/widgets/audio_voice_controls.dart';
import 'package:protectic/widgets/custom_home_button.dart';
import 'package:protectic/widgets/section_title.dart';
import 'package:protectic/widgets/pin_input.dart';

class SetNewPinScreen extends StatefulWidget {
  const SetNewPinScreen({super.key});

  @override
  State<SetNewPinScreen> createState() => _SetNewPinScreenState();
}

class _SetNewPinScreenState extends State<SetNewPinScreen> {
  final _pin1 = TextEditingController();
  final _pin2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4D3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4D3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 40),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SectionTitle('Ingresa un PIN de 4 dígitos'),
                    PinInput(controller: _pin1),
                    const SizedBox(height: 24),
                    const SectionTitle('Ingresa nuevamente tu PIN'),
                    PinInput(controller: _pin2),
                    const SizedBox(height: 32),
                    CustomHomeButton(
                      text: 'Guardar PIN',
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const SuccessDialog(),
                        );
                      },
                    ),
                    const SizedBox(height: 48),
                    const AudioVoiceControls(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
