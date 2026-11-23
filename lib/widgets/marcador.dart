import 'package:flutter/material.dart';

import '../theme/arcade_theme.dart';

/// Casilla de marcador: un número grande con su etiqueta debajo.
class Marcador extends StatelessWidget {
  const Marcador({super.key, required this.etiqueta, required this.valor, required this.color});

  final String etiqueta;
  final String valor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: ArcadeColores.tarjeta,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.6)),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.w900),
            ),
            Text(
              etiqueta.toUpperCase(),
              style: const TextStyle(
                color: ArcadeColores.textoSuave,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fila de marcadores separados por un hueco.
class FilaMarcadores extends StatelessWidget {
  const FilaMarcadores({super.key, required this.children});

  final List<Marcador> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          children[i],
        ],
      ],
    );
  }
}
