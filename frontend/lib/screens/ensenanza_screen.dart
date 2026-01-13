import 'package:flutter/material.dart';
import '../widgets/audio_voice_controls.dart';

class EnsenanzaScreen extends StatefulWidget {
  const EnsenanzaScreen({super.key});

  @override
  State<EnsenanzaScreen> createState() => _EnsenanzaScreenState();
}

class _EnsenanzaScreenState extends State<EnsenanzaScreen> {
  int moduloActual = 0;

  final List<Map<String, dynamic>> modulos = [
    {
      'titulo': 'Mensajes sospechosos (SMS, WhatsApp)',
      'contenido': 'Evita responder mensajes que te piden dinero o datos personales. Verifica con fuentes confiables.',
      'icon': Icons.sms,
      'quiz': {
        'pregunta': '¿Qué haces si recibes un mensaje de un número desconocido pidiendo dinero?',
        'opciones': [
          'Le transfieres porque dice ser tu hijo',
          'Verificas por otro medio antes de responder',
          'Lo ignoras y borras sin pensar'
        ],
        'respuesta': 'Verificas por otro medio antes de responder'
      },
    },
    {
      'titulo': 'Llamadas falsas',
      'contenido': 'Si alguien se hace pasar por un funcionario o familiar, cuelga y llama tú mismo a un número confiable.',
      'icon': Icons.call,
      'quiz': {
        'pregunta': 'Si alguien llama diciendo ser de tu banco, ¿qué debes hacer?',
        'opciones': [
          'Dar tus datos rápido',
          'Colgar y llamar directamente al banco',
          'Preguntar su nombre completo y continuar'
        ],
        'respuesta': 'Colgar y llamar directamente al banco'
      },
    },
    {
      'titulo': 'Correos electrónicos peligrosos',
      'contenido': 'Evita abrir archivos o enlaces de correos extraños, incluso si parecen urgentes.',
      'icon': Icons.email,
      'quiz': {
        'pregunta': '¿Qué indica que un correo puede ser falso?',
        'opciones': [
          'Tiene errores ortográficos y urgencia',
          'Viene de tu jefe',
          'No tiene asunto'
        ],
        'respuesta': 'Tiene errores ortográficos y urgencia'
      },
    },
    {
      'titulo': 'Descarga de archivos peligrosos',
      'contenido': 'No descargues archivos de páginas no oficiales o que llegan por mensajes inesperados.',
      'icon': Icons.download,
      'quiz': {
        'pregunta': '¿Qué debes hacer antes de descargar un archivo?',
        'opciones': [
          'Ver si pesa poco',
          'Revisar que sea de una fuente confiable',
          'Abrirlo y ver qué pasa'
        ],
        'respuesta': 'Revisar que sea de una fuente confiable'
      },
    },
    {
      'titulo': 'Sospecha de cosas que no conoces',
      'contenido': 'Si algo te parece raro, investiga o pregunta antes de actuar. La precaución es tu mejor defensa.',
      'icon': Icons.visibility_off,
      'quiz': {
        'pregunta': '¿Qué actitud es clave ante posibles estafas?',
        'opciones': [
          'Confianza inmediata',
          'Sospecha y verificación',
          'Ignorar todo'
        ],
        'respuesta': 'Sospecha y verificación'
      },
    },
    {
      'titulo': 'Indicaciones oficiales del banco',
      'contenido': 'Tu banco nunca te pedirá contraseñas por llamada o mensaje. Confirma siempre por canales oficiales.',
      'icon': Icons.account_balance,
      'quiz': {
        'pregunta': '¿Cuál es una señal de alerta en una supuesta llamada del banco?',
        'opciones': [
          'Te piden tus claves',
          'Te ofrecen una promoción',
          'Te saludan con tu nombre completo'
        ],
        'respuesta': 'Te piden tus claves'
      },
    },
  ];

  void avanzarModulo() {
    if (moduloActual < modulos.length - 1) {
      setState(() {
        moduloActual++;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🎉 ¡Felicidades!'),
          content: const Text('Has completado todos los módulos. Ahora sabes cómo protegerte de las ciberestafas.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final modulo = modulos[moduloActual];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zona de Enseñanza'),
        backgroundColor: const Color(0xFF795548),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressBar(),

            const SizedBox(height: 20),

            Text(
              'Módulo ${moduloActual + 1}: ${modulo['titulo']}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Card(
              color: Colors.yellow.shade50,
              elevation: 3,
              child: ListTile(
                leading: Icon(modulo['icon'], color: const Color(0xFF795548), size: 40),
                title: Text(modulo['titulo'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(modulo['contenido']),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Prueba del módulo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildQuizCard(
              context,
              pregunta: modulo['quiz']['pregunta'],
              opcionCorrecta: modulo['quiz']['respuesta'],
              opciones: List<String>.from(modulo['quiz']['opciones']),
              onCorrect: avanzarModulo,
              tituloModulo: modulo['titulo'],
            ),

            const SizedBox(height: 40),
            const SizedBox(height: 64, child: AudioVoiceControls()),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(modulos.length, (index) {
        final isCompleted = index < moduloActual;
        final isCurrent = index == moduloActual;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isCompleted
                    ? Colors.green
                    : isCurrent
                        ? const Color(0xFF795548)
                        : Colors.grey.shade300,
                child: Icon(
                  isCompleted ? Icons.check : modulos[index]['icon'],
                  color: isCompleted || isCurrent ? Colors.white : Colors.black38,
                  size: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${index + 1}',
                style: TextStyle(
                  color: isCurrent ? const Color(0xFF795548) : Colors.black54,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuizCard(
    BuildContext context, {
    required String pregunta,
    required String opcionCorrecta,
    required List<String> opciones,
    required VoidCallback onCorrect,
    required String tituloModulo,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pregunta, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...opciones.map((opcion) {
              final isCorrect = opcion == opcionCorrecta;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 2,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    side: const BorderSide(color: Color(0xFF795548)),
                  ),
                  icon: const Icon(Icons.security),
                  label: Text(opcion),
                  onPressed: () {
                    if (isCorrect) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('✅ ¡Correcto!'),
                          content: Text(
                            'Muy bien. Esta es la respuesta correcta porque:\n\n${_explicacionDeLaRespuesta(tituloModulo)}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onCorrect();
                              },
                              child: const Text('Siguiente módulo'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('❌ Intenta de nuevo.'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _explicacionDeLaRespuesta(String titulo) {
    switch (titulo) {
      case 'Mensajes sospechosos (SMS, WhatsApp)':
        return 'Debes verificar antes de actuar porque los estafadores se hacen pasar por familiares o entidades conocidas.';
      case 'Llamadas falsas':
        return 'Nunca des datos por teléfono. Si cuelgas y llamas tú mismo al número oficial, evitas fraudes.';
      case 'Correos electrónicos peligrosos':
        return 'Los correos falsos suelen tener errores y generar urgencia para engañarte.';
      case 'Descarga de archivos peligrosos':
        return 'Las descargas de sitios desconocidos pueden contener virus o malware.';
      case 'Sospecha de cosas que no conoces':
        return 'Es mejor detenerse y verificar. La duda es tu herramienta de protección.';
      case 'Indicaciones oficiales del banco':
        return 'Los bancos nunca piden tus claves. Si lo hacen, es fraude seguro.';
      default:
        return 'Esta opción es la más segura y recomendada para evitar caer en ciberestafas.';
    }
  }
}
