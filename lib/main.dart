import 'package:flutter/material.dart';

import 'screens/catalogo_screen.dart';
import 'theme/arcade_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDITflix Arcade',
      debugShowCheckedModeBanner: false,
      theme: temaArcade(),
      home: const CatalogoScreen(),
    );
  }
}
