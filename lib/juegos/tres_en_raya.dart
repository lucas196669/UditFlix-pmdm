import 'dart:math';

import 'package:flutter/material.dart';

import '../data/records.dart';
import '../models/contenido.dart';
import '../theme/arcade_theme.dart';
import '../widgets/aviso_record.dart';
import '../widgets/marcador.dart';

const List<List<int>> _lineas = [
  [0, 1, 2], [3, 4, 5], [6, 7, 8], // filas
  [0, 3, 6], [1, 4, 7], [2, 5, 8], // columnas
  [0, 4, 8], [2, 4, 6], // diagonales
];

/// 'X' u 'O' si alguien ha hecho tres en raya, 'empate' si el tablero está lleno,
/// o null si la partida sigue.
String? ganadorTresEnRaya(List<String?> tablero) {
  for (final linea in _lineas) {
    final ficha = tablero[linea[0]];
    if (ficha != null && ficha == tablero[linea[1]] && ficha == tablero[linea[2]]) {
      return ficha;
    }
  }
  return tablero.every((casilla) => casilla != null) ? 'empate' : null;
}

/// Casilla que elige la máquina (O): gana si puede, si no te bloquea,
/// si no coge el centro y si no, una casilla libre al azar.
int jugadaMaquina(List<String?> tablero, Random azar) {
  int? completar(String ficha) {
    for (final linea in _lineas) {
      final valores = [for (final i in linea) tablero[i]];
      if (valores.where((v) => v == ficha).length == 2 && valores.contains(null)) {
        return linea[valores.indexOf(null)];
      }
    }
    return null;
  }

  final ganar = completar('O');
  if (ganar != null) return ganar;
  final bloquear = completar('X');
  if (bloquear != null) return bloquear;
  if (tablero[4] == null) return 4;
  final libres = [for (var i = 0; i < tablero.length; i++) if (tablero[i] == null) i];
  return libres[azar.nextInt(libres.length)];
}

class TresEnRaya extends StatefulWidget {
  const TresEnRaya({super.key, required this.juego, this.azar});

  final Contenido juego;
  final Random? azar;

  @override
  State<TresEnRaya> createState() => _TresEnRayaState();
}

class _TresEnRayaState extends State<TresEnRaya> {
  late final Random _azar = widget.azar ?? Random();
  List<String?> _tablero = List<String?>.filled(9, null);
  String? _final;
  int _victorias = 0;
  int _derrotas = 0;
  int _empates = 0;

  void _tocar(int casilla) {
    if (_tablero[casilla] != null || _final != null) return;
    setState(() => _tablero[casilla] = 'X');
    if (_comprobar()) return;
    final respuesta = jugadaMaquina(_tablero, _azar);
    setState(() => _tablero[respuesta] = 'O');
    _comprobar();
  }

  /// Mira si la partida ha terminado. Devuelve true si ha terminado.
  bool _comprobar() {
    final resultado = ganadorTresEnRaya(_tablero);
    if (resultado == null) return false;
    setState(() {
      _final = resultado;
      if (resultado == 'X') {
        _victorias++;
      } else if (resultado == 'O') {
        _derrotas++;
      } else {
        _empates++;
      }
    });
    if (resultado == 'X' && Records.guardar(widget.juego, _victorias)) {
      avisarRecord(context, widget.juego, _victorias);
    }
    return true;
  }

  void _nuevaPartida() {
    setState(() {
      _tablero = List<String?>.filled(9, null);
      _final = null;
    });
  }

  String get _estado => switch (_final) {
        'X' => '¡Has ganado!',
        'O' => 'Gana la máquina',
        'empate' => 'Empate',
        _ => 'Tu turno: pon una X',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilaMarcadores(
          children: [
            Marcador(etiqueta: 'Victorias', valor: '$_victorias', color: ArcadeColores.verde),
            Marcador(etiqueta: 'Empates', valor: '$_empates', color: ArcadeColores.textoSuave),
            Marcador(etiqueta: 'Derrotas', valor: '$_derrotas', color: ArcadeColores.rosa),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _estado,
          key: const ValueKey('estado'),
          style: TextStyle(color: widget.juego.color, fontSize: 22, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i < 9; i++) _Casilla(ficha: _tablero[i], indice: i, alTocar: () => _tocar(i)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _nuevaPartida,
          icon: const Icon(Icons.refresh),
          label: const Text('NUEVA PARTIDA'),
        ),
      ],
    );
  }
}

class _Casilla extends StatelessWidget {
  const _Casilla({required this.ficha, required this.indice, required this.alTocar});

  final String? ficha;
  final int indice;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final color = ficha == 'X' ? ArcadeColores.cian : ArcadeColores.rosa;
    return Material(
      color: ArcadeColores.tarjeta,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: ValueKey('casilla-$indice'),
        borderRadius: BorderRadius.circular(16),
        onTap: alTocar,
        child: Center(
          child: Text(
            ficha ?? '',
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              shadows: [Shadow(color: color, blurRadius: 18)],
            ),
          ),
        ),
      ),
    );
  }
}
