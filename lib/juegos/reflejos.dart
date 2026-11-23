import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data/records.dart';
import '../models/contenido.dart';
import '../theme/arcade_theme.dart';
import '../widgets/aviso_record.dart';
import '../widgets/marcador.dart';

class Reflejos extends StatefulWidget {
  const Reflejos({super.key, required this.juego, this.azar, this.segundos = 20});

  final Contenido juego;
  final Random? azar;

  /// Duración de la partida.
  final int segundos;

  @override
  State<Reflejos> createState() => _ReflejosState();
}

class _ReflejosState extends State<Reflejos> {
  static const double _diana = 72;

  late final Random _azar = widget.azar ?? Random();
  Timer? _reloj;
  late int _quedan = widget.segundos;
  int _toques = 0;
  bool _jugando = false;
  bool _terminada = false;

  /// Posición de la diana, de 0 a 1 en cada eje.
  Offset _posicion = const Offset(0.5, 0.5);

  @override
  void dispose() {
    // Si salimos a mitad de partida, el reloj se para aquí.
    _reloj?.cancel();
    super.dispose();
  }

  void _empezar() {
    setState(() {
      _jugando = true;
      _terminada = false;
      _toques = 0;
      _quedan = widget.segundos;
      _mover();
    });
    _reloj = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _quedan--);
      if (_quedan <= 0) _terminar();
    });
  }

  void _terminar() {
    _reloj?.cancel();
    _reloj = null;
    setState(() {
      _jugando = false;
      _terminada = true;
    });
    if (Records.guardar(widget.juego, _toques)) {
      avisarRecord(context, widget.juego, _toques);
    }
  }

  void _mover() => _posicion = Offset(_azar.nextDouble(), _azar.nextDouble());

  void _tocarDiana() {
    if (!_jugando) return;
    setState(() {
      _toques++;
      _mover();
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.juego.color;
    return Column(
      children: [
        FilaMarcadores(
          children: [
            Marcador(etiqueta: 'Segundos', valor: '$_quedan', color: color),
            Marcador(etiqueta: 'Toques', valor: '$_toques', color: ArcadeColores.cian),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ArcadeColores.tarjeta,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
            ),
            child: LayoutBuilder(
              builder: (context, limites) {
                if (!_jugando) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_terminada)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              '¡Tiempo! Has hecho $_toques toques',
                              key: const ValueKey('resultado'),
                              style: const TextStyle(color: ArcadeColores.texto, fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                          ),
                        FilledButton.icon(
                          key: const ValueKey('empezar'),
                          onPressed: _empezar,
                          style: FilledButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(_terminada ? 'OTRA VEZ' : 'EMPEZAR'),
                        ),
                      ],
                    ),
                  );
                }
                final x = _posicion.dx * (limites.maxWidth - _diana);
                final y = _posicion.dy * (limites.maxHeight - _diana);
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 120),
                      left: x,
                      top: y,
                      child: GestureDetector(
                        key: const ValueKey('diana'),
                        onTap: _tocarDiana,
                        child: Container(
                          width: _diana,
                          height: _diana,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [Colors.white, color, color.withValues(alpha: 0.2)]),
                            boxShadow: [BoxShadow(color: color, blurRadius: 24)],
                          ),
                          child: const Icon(Icons.ads_click, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
