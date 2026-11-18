import 'package:flutter/material.dart';

/// Tema único de UDITflix: oscuro, Material 3 y con el morado UDIT
/// (#5B2D90, el color que ya usaba la app) como único color de acento.
/// Lo usan el catálogo, la ficha, el reproductor y UDIT Arcade.
class AppTheme {
  AppTheme._();

  // Paleta de UDITflix.
  static const Color morado = Color(0xFF5B2D90); // acento de marca
  static const Color moradoClaro = Color(0xFFB794F4); // acento sobre fondo oscuro
  static const Color fondo = Color(0xFF0E0B14);
  static const Color superficie = Color(0xFF1A1523);
  static const Color superficieAlta = Color(0xFF262033);
  static const Color texto = Color(0xFFF4F1F8);
  static const Color textoSecundario = Color(0xFFB3ABC2);
  static const Color valoracion = Color(0xFFFFC94D);

  static ThemeData get oscuro {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: morado,
      brightness: Brightness.dark,
    ).copyWith(
      primary: moradoClaro,
      onPrimary: fondo,
      primaryContainer: morado,
      onPrimaryContainer: texto,
      surface: superficie,
      onSurface: texto,
    );

    const textTheme = TextTheme(
      headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: texto, letterSpacing: -0.5),
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: texto),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: texto),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: texto),
      bodyLarge: TextStyle(fontSize: 16, color: texto, height: 1.4),
      bodyMedium: TextStyle(fontSize: 14, color: textoSecundario, height: 1.4),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.3),
      labelSmall: TextStyle(fontSize: 12, color: textoSecundario),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: fondo,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: fondo,
        foregroundColor: texto,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: moradoClaro,
          letterSpacing: 1,
        ),
      ),
      cardTheme: CardThemeData(
        color: superficie,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: superficieAlta,
        labelStyle: const TextStyle(color: texto, fontSize: 12, fontWeight: FontWeight.w600),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 6),
      ),
      iconTheme: const IconThemeData(color: texto, size: 24),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: morado,
          foregroundColor: texto,
          minimumSize: const Size(48, 48),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: moradoClaro),
      sliderTheme: const SliderThemeData(
        activeTrackColor: moradoClaro,
        thumbColor: moradoClaro,
        inactiveTrackColor: superficieAlta,
      ),
    );
  }
}
