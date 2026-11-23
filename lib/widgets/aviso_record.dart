import 'package:flutter/material.dart';

import '../models/contenido.dart';

/// Muestra un aviso abajo cuando se consigue un récord nuevo.
void avisarRecord(BuildContext context, Contenido juego, int puntos) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: juego.color,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '¡Nuevo récord! $puntos ${juego.unidadRecord}',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    ),
  );
}
