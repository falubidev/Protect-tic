import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:protectic/screens/recover_pin/recover_pin_screen.dart';
import 'dart:convert';

import '../widgets/custom_home_button.dart';
import '../widgets/audio_voice_controls.dart';
import '../widgets/pin_input.dart';
import 'user_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController phoneController;
  late TextEditingController pinController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    pinController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    pinController.dispose();
    super.dispose();
  }

  SnackBar _buildStyledSnackBar({
    required String message,
    required bool isSuccess,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: isSuccess
          ? const Color(0xFFD4EDDA)
          : const Color(0xFFF8D7DA),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
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
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ingresa tu número telefónico',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ingresa tu PIN',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    PinInput(controller: pinController),
                    const SizedBox(height: 32),
                    CustomHomeButton(
                      text: 'Iniciar sesión',
                      onPressed: () async {
                        final phone = phoneController.text.trim();
                        final pin = pinController.text.trim();

                        if (phone.isEmpty || pin.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            _buildStyledSnackBar(
                              message: 'Por favor ingresa tu teléfono y PIN',
                              isSuccess: false,
                            ),
                          );
                          return;
                        }

                        try {
                          final response = await http.post(
                            Uri.parse('http://192.168.1.4:3000/login')
,
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({'phone': phone, 'pin': pin}),
                          );

                          final data = jsonDecode(response.body);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              _buildStyledSnackBar(
                                message:
                                    data['message'] ??
                                    'Inicio de sesión exitoso',
                                isSuccess: true,
                              ),
                            );

                            final userName = data['name'] ?? 'Usuario';

                            await Future.delayed(const Duration(seconds: 2));
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserHomeScreen(name: userName),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              _buildStyledSnackBar(
                                message:
                                    data['error'] ?? 'Credenciales inválidas',
                                isSuccess: false,
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            _buildStyledSnackBar(
                              message: 'Error de red',
                              isSuccess: false,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        '¿Olvidaste tu PIN?',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomHomeButton(
                      text: 'Recuperar PIN',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RecoverPinScreen(),
                          ),
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
