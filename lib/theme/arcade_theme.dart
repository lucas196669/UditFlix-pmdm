import 'package:flutter/material.dart';

/// Colores del estilo "arcade" de la app: fondo morado oscuro y luces de neón.
class ArcadeColores {
  static const Color fondo = Color(0xFF120B2E);
  static const Color fondoClaro = Color(0xFF2A1252);
  static const Color tarjeta = Color(0xFF1E1440);
  static const Color texto = Color(0xFFF4F1FF);
  static const Color textoSuave = Color(0xFFB9B0D9);
  static const Color morado = Color(0xFF7C4DFF);
  static const Color rosa = Color(0xFFFF4FA3);
  static const Color cian = Color(0xFF00E5FF);
  static const Color verde = Color(0xFF39FF88);
  static const Color amarillo = Color(0xFFFFD54F);
  static const Color naranja = Color(0xFFFF8A3D);
}

/// Tema oscuro de la app.
ThemeData temaArcade() {
  final esquema = ColorScheme.fromSeed(
    seedColor: ArcadeColores.morado,
    brightness: Brightness.dark,
  ).copyWith(
    primary: ArcadeColores.morado,
    secondary: ArcadeColores.cian,
    surface: ArcadeColores.tarjeta,
    onSurface: ArcadeColores.texto,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: esquema,
    scaffoldBackgroundColor: ArcadeColores.fondo,
    appBarTheme: const AppBarTheme(
      backgroundColor: ArcadeColores.fondo,
      foregroundColor: ArcadeColores.texto,
      elevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ArcadeColores.rosa,
        foregroundColor: Colors.white,
        minimumSize: const Size(0, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.2),
      ),
    ),
  );
}

/// Fondo degradado que comparten todas las pantallas.
class FondoArcade extends StatelessWidget {
  const FondoArcade({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ArcadeColores.fondoClaro, ArcadeColores.fondo],
        ),
      ),
      child: child,
    );
  }
}
