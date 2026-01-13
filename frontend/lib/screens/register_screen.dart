import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/custom_home_button.dart';
import '../widgets/audio_voice_controls.dart';
import '../widgets/pin_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController pinController;
  late TextEditingController confirmPinController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    pinController = TextEditingController();
    confirmPinController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    pinController.dispose();
    confirmPinController.dispose();
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
        title: null,
        automaticallyImplyLeading: false,
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
                      '¿Cómo quieres que te llamemos?',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ingresa tu número telefónico',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Ingresa un PIN de 4 dígitos',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    PinInput(controller: pinController),
                    const SizedBox(height: 16),
                    const Text(
                      'Ingresa nuevamente tu PIN',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    PinInput(controller: confirmPinController),
                    const SizedBox(height: 32),
                    CustomHomeButton(
                      text: 'Registrarse',
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final phone = phoneController.text.trim();
                        final pin = pinController.text.trim();
                        final confirmPin = confirmPinController.text.trim();

                        if (name.isEmpty ||
                            phone.isEmpty ||
                            pin.isEmpty ||
                            confirmPin.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            _buildStyledSnackBar(
                              message: 'Por favor completa todos los campos',
                              isSuccess: false,
                            ),
                          );
                          return;
                        }

                        if (pin != confirmPin) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            _buildStyledSnackBar(
                              message: 'Los PIN no coinciden',
                              isSuccess: false,
                            ),
                          );
                          return;
                        }

                        try {
                          final response = await http.post(
                            Uri.parse('http://192.168.1.4:3000/register'),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({
                              'name': name,
                              'phone': phone,
                              'pin': pin,
                            }),
                          );

                          final data = jsonDecode(response.body);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              _buildStyledSnackBar(
                                message: data['message'] ?? 'Registro exitoso',
                                isSuccess: true,
                              ),
                            );
                            await Future.delayed(const Duration(seconds: 2));
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              _buildStyledSnackBar(
                                message: data['error'] ?? 'Error al registrar',
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
