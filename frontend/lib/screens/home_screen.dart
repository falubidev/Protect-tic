import 'package:flutter/material.dart';
import '../widgets/custom_home_button.dart';
import '../widgets/audio_voice_controls.dart';
import 'register_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4D3),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFF795548), width: 8),
          // Curvatura de todo el borde
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ProtecTIC',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 48,
                              letterSpacing: 4.8,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Image.asset('assets/logo.png', height: 200),
                          const SizedBox(height: 24),
                          CustomHomeButton(
                            text: 'Iniciar sesión',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            '¿Aún no te has registrado?',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomHomeButton(
                            text: 'Registrarse',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 48),
                          AudioVoiceControls(
                            audioText:
                                "Bienvenido a ProtecTIC. Di iniciar sesión o registrarse para continuar.",
                            onVoiceCommand: (command) {
                              final cmd = command.toLowerCase();
                              if (cmd.contains('iniciar') ||
                                  cmd.contains('iniciar sesión')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              } else if (cmd.contains('registrarse') ||
                                  cmd.contains('registro')) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
