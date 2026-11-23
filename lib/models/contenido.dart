import 'package:flutter/material.dart';

/// Cómo se compara una puntuación para saber si es récord.
enum TipoRecord {
  /// Más puntos es mejor (victorias, toques...).
  masEsMejor,

  /// Menos es mejor (intentos, movimientos...).
  menosEsMejor,
}

/// Un contenido del catálogo de UDITflix Arcade: un minijuego.
class Contenido {
  const Contenido({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.descripcion,
    required this.instrucciones,
    required this.icono,
    required this.color,
    required this.dificultad,
    required this.tipoRecord,
    required this.unidadRecord,
  });

  final String id;
  final String titulo;

  /// Habilidad, Lógica, Azar o Memoria.
  final String categoria;
  final String descripcion;
  final List<String> instrucciones;
  final IconData icono;

  /// Color de neón del juego (borde, icono y botones).
  final Color color;

  /// De 1 (fácil) a 3 (difícil).
  final int dificultad;

  final TipoRecord tipoRecord;

  /// Qué se cuenta en el récord: "victorias seguidas", "intentos"...
  final String unidadRecord;
}
