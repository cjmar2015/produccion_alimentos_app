import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ProduccionApp());
}

class ProduccionApp extends StatelessWidget {
  const ProduccionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Producción Alimentos',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF600F40), // 🎨 PÚRPURA DE TIRO
          primary: const Color(0xFF600F40), // Púrpura principal
          secondary: const Color(0xFF87556B), // 💜 HEXO BÍBLIA
          tertiary: const Color(0xFFB07992), // 🌸 VIOLETA CLARO
          surface: const Color(0xFFD4B0C4), // 🌷 LAVANDA (fondos)
          brightness: Brightness.light,
        ),
        fontFamily: 'System',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF600F40), // Púrpura principal
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF600F40), // Púrpura principal
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF87556B), // Hexo Bíblia
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
