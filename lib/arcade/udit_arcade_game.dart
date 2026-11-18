import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'components/limite.dart';
import 'components/marcador.dart';
import 'components/palomita.dart';
import 'components/tira_pelicula.dart';

enum EstadoJuego { inicio, jugando, gameOver }

/// UDIT Arcade: juego estilo "Flappy" con una palomita que esquiva tiras de película.
///
/// Bucle de juego: Flame llama ~60 veces por segundo a update(dt) de cada
/// componente (lógica: gravedad, movimiento, puntuación) y después a render()
/// (dibujo con Canvas). dt son los segundos desde el fotograma anterior.
class UditArcadeGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  static const String overlayInicio = 'inicio';
  static const String overlayGameOver = 'gameOver';

  static const double alturaSuelo = 70;
  static const int numeroObstaculos = 3;
  static const double separacionObstaculos = 280;
  static const double velocidadObstaculos = 170; // píxeles por segundo

  /// Mejor puntuación de la sesión (static: se conserva al salir y volver a entrar).
  static int _mejorRecord = 0;

  final Random random;
  EstadoJuego estado = EstadoJuego.inicio;
  int puntuacion = 0;

  late final Palomita palomita;
  final List<ParTirasPelicula> obstaculos = [];

  UditArcadeGame({Random? random}) : random = random ?? Random();

  int get mejorRecord => _mejorRecord;

  @override
  Color backgroundColor() => AppTheme.fondo;

  @override
  Future<void> onLoad() async {
    palomita = Palomita();
    addAll([Limite.techo(), Limite.suelo(), palomita, Marcador()]);
    for (var i = 0; i < numeroObstaculos; i++) {
      final obstaculo = ParTirasPelicula();
      obstaculos.add(obstaculo);
      add(obstaculo);
    }
    _colocarElementos();
  }

  void _colocarElementos() {
    palomita.reiniciar(Vector2(size.x * 0.28, (size.y - alturaSuelo) / 2));
    for (var i = 0; i < obstaculos.length; i++) {
      _colocar(obstaculos[i], size.x + 80 + i * separacionObstaculos);
    }
  }

  void _colocar(ParTirasPelicula obstaculo, double x) {
    obstaculo.colocar(x: x, altoJugable: size.y - alturaSuelo, random: random);
  }

  /// Reciclaje: el obstáculo que sale por la izquierda se recoloca detrás del
  /// último, con un hueco nuevo aleatorio (no se crean objetos nuevos).
  void reciclar(ParTirasPelicula obstaculo) {
    final xUltimo = obstaculos.map((o) => o.position.x).reduce(max);
    _colocar(obstaculo, xUltimo + separacionObstaculos);
  }

  /// Cada toque: en la pantalla de inicio empieza la partida; jugando, salta.
  @override
  void onTapDown(TapDownEvent event) {
    switch (estado) {
      case EstadoJuego.inicio:
        empezar();
        palomita.saltar();
      case EstadoJuego.jugando:
        palomita.saltar();
      case EstadoJuego.gameOver:
        break; // en Game Over se usa el botón "Reiniciar"
    }
  }

  void empezar() {
    estado = EstadoJuego.jugando;
    overlays.remove(overlayInicio);
  }

  /// Puntuación: suma 1 cada vez que la palomita deja atrás un obstáculo.
  void sumarPunto() {
    puntuacion++;
    if (puntuacion > _mejorRecord) _mejorRecord = puntuacion;
  }

  /// Se llama al chocar: congela el juego y muestra el overlay de Game Over.
  void terminar() {
    if (estado != EstadoJuego.jugando) return;
    estado = EstadoJuego.gameOver;
    pauseEngine();
    overlays.add(overlayGameOver);
  }

  void reiniciar() {
    puntuacion = 0;
    estado = EstadoJuego.inicio;
    overlays.remove(overlayGameOver);
    _colocarElementos();
    overlays.add(overlayInicio);
    resumeEngine();
  }
}
