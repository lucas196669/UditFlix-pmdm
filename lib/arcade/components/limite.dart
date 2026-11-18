import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../theme/app_theme.dart';
import '../udit_arcade_game.dart';

/// Suelo y techo del juego. Tienen RectangleHitbox para detectar el choque.
class Limite extends PositionComponent {
  final bool esSuelo;

  Limite.suelo() : esSuelo = true, super(priority: 1);
  Limite.techo() : esSuelo = false, super(priority: 1);

  @override
  Future<void> onLoad() async => add(RectangleHitbox());

  /// Se recoloca cada vez que cambia el tamaño de la pantalla.
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (esSuelo) {
      position = Vector2(0, size.y - UditArcadeGame.alturaSuelo);
      this.size = Vector2(size.x, UditArcadeGame.alturaSuelo);
    } else {
      // El techo queda justo por encima del borde superior (invisible).
      position = Vector2(0, -20);
      this.size = Vector2(size.x, 20);
    }
  }

  static final Paint _base = Paint()..color = AppTheme.superficie;
  static final Paint _linea = Paint()..color = AppTheme.moradoClaro;
  static final Paint _marca = Paint()..color = AppTheme.superficieAlta;

  @override
  void render(Canvas canvas) {
    if (!esSuelo) return;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _base);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 4), _linea);
    // Franja de "butacas" decorativa.
    for (var x = 8.0; x < size.x; x += 28) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, 18, 18, 14), const Radius.circular(4)),
        _marca,
      );
    }
  }
}
