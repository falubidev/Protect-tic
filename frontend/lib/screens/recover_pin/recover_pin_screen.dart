import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:protectic/screens/recover_pin/verify_code_screen.dart';
import 'package:protectic/widgets/custom_home_button.dart';
import 'package:protectic/widgets/section_title.dart';
import 'package:protectic/widgets/underline_text_field.dart';

class RecoverPinScreen extends StatefulWidget {
  const RecoverPinScreen({super.key});

  @override
  State<RecoverPinScreen> createState() => _RecoverPinScreenState();
}

class _RecoverPinScreenState extends State<RecoverPinScreen> {
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _phoneCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
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
                    const SectionTitle('Ingresa tu número telefónico'),
                    const SizedBox(height: 16),
                    UnderlineTextField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    const SizedBox(height: 32),
                    CustomHomeButton(
                      text: 'Enviar código',
                      onPressed: () {
  final phone = _phoneCtrl.text.trim();
  if (phone.isEmpty) return;

  final fullPhoneNumber = '+57$phone';

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Recuperación por SMS deshabilitada (Firebase removido).')),
  );

  // Si quieres mantener el flujo de pantallas sin Firebase:
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => VerifyCodeScreen(
        verificationId: 'DISABLED',
        phoneNumber: fullPhoneNumber,
      ),
    ),
  );
},

                    ),
                    const SizedBox(height: 48),
                    // const AudioVoiceControls(),
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
