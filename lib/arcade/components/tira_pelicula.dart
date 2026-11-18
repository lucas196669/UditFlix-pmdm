import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../theme/app_theme.dart';
import '../udit_arcade_game.dart';

/// Pareja de obstáculos (tira de arriba + tira de abajo) con un hueco entre ellas.
class ParTirasPelicula extends PositionComponent with HasGameReference<UditArcadeGame> {
  static const double ancho = 72;
  static const double hueco = 175; // espacio por el que pasa la palomita
  static const double margen = 50; // altura mínima de cada tira

  final TiraPelicula superior = TiraPelicula(arriba: true);
  final TiraPelicula inferior = TiraPelicula(arriba: false);

  /// Indica si ya se ha sumado el punto de este obstáculo.
  bool superado = false;

  ParTirasPelicula() : super(size: Vector2(ancho, 0)) {
    addAll([superior, inferior]);
  }

  /// Coloca el obstáculo en [x] con un hueco a altura aleatoria.
  void colocar({required double x, required double altoJugable, required Random random}) {
    position = Vector2(x, 0);
    superado = false;

    final rango = max(0.0, altoJugable - 2 * margen - hueco);
    final inicioHueco = margen + random.nextDouble() * rango;
    final finHueco = inicioHueco + hueco;

    superior
      ..position = Vector2.zero()
      ..size = Vector2(ancho, inicioHueco);
    inferior
      ..position = Vector2(0, finHueco)
      ..size = Vector2(ancho, max(0, altoJugable - finHueco));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.estado != EstadoJuego.jugando) return;

    // Los obstáculos se desplazan hacia la izquierda a velocidad constante.
    position.x -= UditArcadeGame.velocidadObstaculos * dt;

    // Puntuación: cuando el borde derecho del obstáculo queda a la izquierda
    // de la palomita, se suma 1 (solo una vez gracias a "superado").
    if (!superado && position.x + ancho < game.palomita.position.x) {
      superado = true;
      game.sumarPunto();
    }

    // Al salir por la izquierda, se recicla a la derecha.
    if (position.x + ancho < 0) game.reciclar(this);
  }
}

/// Una tira de película: rectángulo de celuloide con los agujeritos laterales.
class TiraPelicula extends PositionComponent {
  final bool arriba;

  TiraPelicula({required this.arriba});

  @override
  Future<void> onLoad() async {
    // Sin tamaño explícito, el RectangleHitbox ocupa toda la tira y se
    // redimensiona solo cuando la tira cambia de altura al reciclarse.
    add(RectangleHitbox());
  }

  static final Paint _celuloide = Paint()..color = const Color(0xFF231C2E);
  static final Paint _fotograma = Paint()..color = AppTheme.morado.withValues(alpha: 0.75);
  static final Paint _agujero = Paint()..color = AppTheme.fondo;
  static final Paint _borde = Paint()
    ..color = AppTheme.moradoClaro
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  static final Paint _boca = Paint()..color = AppTheme.moradoClaro;

  @override
  void render(Canvas canvas) {
    if (size.y <= 0) return;
    final w = size.x;
    final h = size.y;
    final rect = Rect.fromLTWH(0, 0, w, h);

    canvas.drawRect(rect, _celuloide);

    // Fotogramas, contados desde la boca para que el patrón quede alineado.
    const altoFotograma = 34.0;
    const separacion = 8.0;
    for (var d = separacion; d < h; d += altoFotograma + separacion) {
      final y = arriba ? h - d - altoFotograma : d;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(15, y, w - 30, altoFotograma), const Radius.circular(3)),
        _fotograma,
      );
    }

    // Agujeritos del celuloide a ambos lados.
    for (var d = 6.0; d < h; d += 13) {
      final y = arriba ? h - d - 6 : d;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(4, y, 6, 6), const Radius.circular(1.5)), _agujero);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w - 10, y, 6, 6), const Radius.circular(1.5)), _agujero);
    }

    canvas.drawRect(rect, _borde);

    // Boca del "tubo" en el extremo que da al hueco.
    const altoBoca = 10.0;
    canvas.drawRect(
      Rect.fromLTWH(-4, arriba ? h - altoBoca : 0, w + 8, altoBoca),
      _boca,
    );
  }
}
