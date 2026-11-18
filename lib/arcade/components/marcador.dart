import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../udit_arcade_game.dart';

/// Contador de puntuación visible en la parte superior.
class Marcador extends TextComponent with HasGameReference<UditArcadeGame> {
  Marcador()
      : super(
          text: '0',
          anchor: Anchor.topCenter,
          priority: 10,
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: AppTheme.texto,
              shadows: [Shadow(color: AppTheme.morado, offset: Offset(3, 3))],
            ),
          ),
        );

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(size.x / 2, 24);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Refleja en pantalla la puntuación actual del juego.
    final valor = '${game.puntuacion}';
    if (text != valor) text = valor;
  }
}
