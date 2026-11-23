import 'package:flutter/material.dart';

import '../theme/arcade_theme.dart';

/// Tres estrellas que indican la dificultad (1 a 3).
class EstrellasDificultad extends StatelessWidget {
  const EstrellasDificultad({super.key, required this.nivel, this.tamano = 16});

  final int nivel;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Dificultad $nivel de 3',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 3; i++)
            Icon(
              i <= nivel ? Icons.star_rounded : Icons.star_outline_rounded,
              size: tamano,
              color: ArcadeColores.amarillo,
            ),
        ],
      ),
    );
  }
}
