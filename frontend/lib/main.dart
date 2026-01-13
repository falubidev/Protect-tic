import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'screens/home_screen.dart';
import 'screens/user_home_screen.dart';
import 'screens/simulacro_screen.dart';
import 'screens/progreso_screen.dart';
import 'screens/ensenanza_screen.dart';
import 'screens/entities_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Inicializa Firebase
  runApp(ProtecTICApp());
}

class ProtecTICApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProtecTIC',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFFDF6D8),
        fontFamily: 'Arial',
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/simulacros': (context) => const SimulacroScreen(),
        '/progreso': (context) => const ProgresoScreen(),
        '/ensenanza': (context) => const EnsenanzaScreen(),
        '/entities': (context) => const EntitiesScreen(),
      },
    );
  }
}
