import 'package:flutter/material.dart';
import 'package:uditflix/screens/catalogo_screen.dart';

import 'screens/catalogo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDITflix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B2D90)),
        scaffoldBackgroundColor: const Color(0xFFF7F5FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5B2D90),
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),

      home: const CatalogoScreen(),
    );
  }
}
