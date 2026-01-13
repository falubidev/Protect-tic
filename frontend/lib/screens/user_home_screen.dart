import 'package:flutter/material.dart';
import '../widgets/audio_voice_controls.dart';

class UserHomeScreen extends StatelessWidget {
  final String name;

  const UserHomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4D3),
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: const Color(0xFFF7F4D3),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF795548)),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('¿Cerrar sesión?'),
                    content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Cerrar sesión'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
  body: Container(

        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF795548), // Café
            width: 7,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Hola $name,\n¿Cómo puedo ayudarte?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isMobile ? 1.2 : 1.4,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    _buildMenuButton(
                      context,
                      Icons.quiz,
                      'Simulacros',
                      isMobile,
                    ),
                    _buildMenuButton(
                      context,
                      Icons.lightbulb_outline,
                      'Consejos',
                      isMobile,
                    ),
                    _buildMenuButton(
                      context,
                      Icons.account_balance,
                      'Entidades Oficiales',
                      isMobile,
                    ),
                    _buildMenuButton(
                      context,
                      Icons.bar_chart,
                      'Ver progreso',
                      isMobile,
                    ),
                    _buildMenuButton(
                      context,
                      Icons.school,
                      'Zona de enseñanza',
                      isMobile,
                    ),
                    _buildMenuButton(context, Icons.school, 'Otros', isMobile),
                  ],
                ),
                const SizedBox(height: 40),
                const SizedBox(height: 64, child: AudioVoiceControls()),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    IconData icon,
    String label,
    bool isMobile,
  ) {
    return ElevatedButton(
      onPressed: () {
        if (label == 'Simulacros') {
          Navigator.pushNamed(context, '/simulacros');
        } else if (label == 'Ver progreso') {
          Navigator.pushNamed(context, '/progreso');
        } else if (label == 'Zona de enseñanza') {
          Navigator.pushNamed(context, '/ensenanza');
        } else if (label == 'Consejos') {
          Navigator.pushNamed(context, '/consejos');
        } else if (label == 'Entidades Oficiales') {
          Navigator.pushNamed(context, '/entities');
        } else {
          print('Botón presionado: $label');
        }
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF795548),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(8),
        minimumSize: isMobile ? const Size(100, 100) : const Size(80, 80),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isMobile ? 28 : 22),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 13 : 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
