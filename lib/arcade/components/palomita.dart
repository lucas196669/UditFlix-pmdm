import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../theme/app_theme.dart';
import '../udit_arcade_game.dart';
import 'limite.dart';
import 'tira_pelicula.dart';

/// Personaje del jugador: una palomita de cine dibujada con Canvas.
class Palomita extends PositionComponent
    with HasGameReference<UditArcadeGame>, CollisionCallbacks {
  static const double gravedad = 1100; // aceleración hacia abajo (px/s²)
  static const double impulsoSalto = 380; // velocidad hacia arriba al tocar (px/s)
  static const double velocidadMaximaCaida = 650;

  double velocidadY = 0;
  double _tiempo = 0;
  double _yInicial = 0;

  Palomita() : super(size: Vector2.all(44), anchor: Anchor.center, priority: 2);

  @override
  Future<void> onLoad() async {
    // Hitbox circular algo menor que el dibujo para que las colisiones sean justas.
    add(CircleHitbox(radius: 17, position: size / 2, anchor: Anchor.center));
  }

  void reiniciar(Vector2 posicionInicial) {
    position = posicionInicial;
    _yInicial = posicionInicial.y;
    velocidadY = 0;
    angle = 0;
    _tiempo = 0;
  }

  /// Salto: sustituye la velocidad vertical por un impulso hacia arriba
  /// (en pantalla la Y crece hacia abajo, por eso es negativo).
  void saltar() => velocidadY = -impulsoSalto;

  @override
  void update(double dt) {
    super.update(dt);
    if (game.estado == EstadoJuego.jugando) {
      // Gravedad: la velocidad aumenta cada fotograma (v = v + g·dt)
      // y la posición avanza según esa velocidad (y = y + v·dt).
      velocidadY = min(velocidadY + gravedad * dt, velocidadMaximaCaida);
      position.y += velocidadY * dt;
      // Se inclina hacia arriba al subir y hacia abajo al caer.
      angle = (velocidadY / 700).clamp(-0.5, 0.9);
    } else if (game.estado == EstadoJuego.inicio) {
      // En la pantalla de inicio flota suavemente.
      _tiempo += dt;
      position.y = _yInicial + sin(_tiempo * 3) * 8;
    }
  }

  /// Colisiones: si la palomita toca una tira de película, el suelo o el
  /// techo, la partida termina.
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is TiraPelicula || other is Limite) game.terminar();
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Palomitas (nubes de color crema) asomando por encima del cubo.
    final crema = Paint()..color = const Color(0xFFFFF1C9);
    final sombra = Paint()..color = const Color(0xFFF2D488);
    for (final c in const [
      Offset(0.28, 0.36), Offset(0.5, 0.26), Offset(0.72, 0.36),
      Offset(0.38, 0.2), Offset(0.62, 0.18),
    ]) {
      canvas.drawCircle(Offset(c.dx * w, c.dy * h + 1.5), w * 0.15, sombra);
      canvas.drawCircle(Offset(c.dx * w, c.dy * h), w * 0.15, crema);
    }

    // Cubo: trapecio blanco con rayas moradas de UDITflix.
    final cubo = Path()
      ..moveTo(w * 0.14, h * 0.42)
      ..lineTo(w * 0.86, h * 0.42)
      ..lineTo(w * 0.74, h)
      ..lineTo(w * 0.26, h)
      ..close();
    canvas.drawPath(cubo, Paint()..color = AppTheme.texto);
    canvas.save();
    canvas.clipPath(cubo);
    final raya = Paint()..color = AppTheme.morado;
    for (var i = 0; i < 4; i++) {
      canvas.drawRect(Rect.fromLTWH(w * (0.1 + i * 0.22), 0, w * 0.1, h), raya);
    }
    canvas.restore();

    // Borde superior del cubo.
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.1, h * 0.4, w * 0.8, h * 0.09), const Radius.circular(3)),
      Paint()..color = AppTheme.moradoClaro,
    );

    // Ojos.
    final ojo = Paint()..color = AppTheme.fondo;
    canvas.drawCircle(Offset(w * 0.4, h * 0.66), w * 0.055, ojo);
    canvas.drawCircle(Offset(w * 0.6, h * 0.66), w * 0.055, ojo);
  }
}
