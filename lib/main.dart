import 'package:flutter/material.dart';

import 'screens/catalogo_screen.dart';
import 'theme/app_theme.dart';

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
      // Tema oscuro común a toda la app (catálogo, reproductor y UDIT Arcade).
      theme: AppTheme.oscuro,
      home: const CatalogoScreen(),
    );
  }
}
