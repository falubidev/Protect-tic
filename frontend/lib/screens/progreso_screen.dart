import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../widgets/audio_voice_controls.dart';

class ProgresoScreen extends StatelessWidget {
  const ProgresoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi progreso'),
        backgroundColor: const Color(0xFF795548),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Tu avance general:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Gráfico circular de progreso
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProgressCircle('Simulacros', 0.7, Icons.quiz, Colors.green),
                _buildProgressCircle('Enseñanza', 0.5, Icons.school, Colors.orange),
                _buildProgressCircle('Interfaz', 0.9, Icons.devices, Colors.blue),
              ],
            ),

            const SizedBox(height: 40),

            const Text(
              'Checklist de logros:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Checklist
            _buildChecklistItem(true, 'Realizaste tu primer simulacro.'),
            _buildChecklistItem(true, 'Aprendiste a identificar un correo sospechoso.'),
            _buildChecklistItem(false, 'Completaste los 3 tipos de simulacros.'),
            _buildChecklistItem(false, 'Terminaste la zona de enseñanza.'),

            const SizedBox(height: 40),
            const SizedBox(height: 64, child: AudioVoiceControls()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCircle(String label, double percent, IconData icon, Color color) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 45.0,
          lineWidth: 8.0,
          percent: percent,
          animation: true,
          animationDuration: 800,
          center: Icon(icon, size: 32, color: color),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: color,
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text('${(percent * 100).toInt()}%'),
      ],
    );
  }

  Widget _buildChecklistItem(bool done, String text) {
    return ListTile(
      leading: Icon(
        done ? Icons.check_circle : Icons.radio_button_unchecked,
        color: done ? Colors.green : Colors.grey,
      ),
      title: Text(
        text,
        style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: 16,
          color: done ? Colors.black : Colors.grey.shade600,
        ),
      ),
    );
  }
}
