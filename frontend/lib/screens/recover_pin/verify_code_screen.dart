import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:protectic/screens/recover_pin/set_new_pin_screen.dart';
import 'package:protectic/widgets/audio_voice_controls.dart';
import 'package:protectic/widgets/custom_home_button.dart';
import 'package:protectic/widgets/section_title.dart';
import 'package:protectic/widgets/underline_text_field.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyCodeScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  late final TextEditingController _codeCtrl;

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  // Future<void> _verifyCode() async {
  //   final smsCode = _codeCtrl.text.trim();
  //   if (smsCode.isEmpty) return;

  //   try {
  //     final credential = PhoneAuthProvider.credential(
  //       verificationId: widget.verificationId,
  //       smsCode: smsCode,
  //     );

  //     // Este paso verifica el código
  //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     // Si el código es correcto, navega a la pantalla de nuevo PIN
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => const SetNewPinScreen()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Código incorrecto o expirado.')),
  //     );
  //   }
  // }
void _verifyCode() {
  final smsCode = _codeCtrl.text.trim();
  if (smsCode.isEmpty) return;

  // Firebase fue removido → simulamos verificación exitosa
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Verificación deshabilitada (Firebase removido).')),
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const SetNewPinScreen()),
  );
}

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
                    const SectionTitle(
                      'Te enviamos un código\n'
                      'de 6 dígitos por WhatsApp.\n'
                      'Escríbelo aquí para continuar.',
                    ),
                    const SizedBox(height: 16),
                    UnderlineTextField(
                      controller: _codeCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 32),
                    CustomHomeButton(
                      text: 'Verificar',
                      onPressed: _verifyCode,
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
