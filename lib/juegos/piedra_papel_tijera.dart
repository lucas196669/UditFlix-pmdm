import 'dart:math';

import 'package:flutter/material.dart';

import '../data/records.dart';
import '../models/contenido.dart';
import '../theme/arcade_theme.dart';
import '../widgets/aviso_record.dart';
import '../widgets/marcador.dart';

enum Jugada { piedra, papel, tijera }

extension JugadaTexto on Jugada {
  String get emoji => switch (this) {
        Jugada.piedra => '✊',
        Jugada.papel => '✋',
        Jugada.tijera => '✌️',
      };

  String get nombre => switch (this) {
        Jugada.piedra => 'Piedra',
        Jugada.papel => 'Papel',
        Jugada.tijera => 'Tijera',
      };
}

/// 1 si gana [jugador], -1 si gana [maquina] y 0 si empatan.
int resultadoPpt(Jugada jugador, Jugada maquina) {
  if (jugador == maquina) return 0;
  final gana = (jugador == Jugada.piedra && maquina == Jugada.tijera) ||
      (jugador == Jugada.papel && maquina == Jugada.piedra) ||
      (jugador == Jugada.tijera && maquina == Jugada.papel);
  return gana ? 1 : -1;
}

class PiedraPapelTijera extends StatefulWidget {
  const PiedraPapelTijera({super.key, required this.juego, this.azar});

  final Contenido juego;

  /// Generador de azar (en las pruebas se pasa uno con semilla fija).
  final Random? azar;

  @override
  State<PiedraPapelTijera> createState() => _PiedraPapelTijeraState();
}

class _PiedraPapelTijeraState extends State<PiedraPapelTijera> {
  late final Random _azar = widget.azar ?? Random();
  int _tu = 0;
  int _maquina = 0;
  int _racha = 0;
  Jugada? _ultimaTuya;
  Jugada? _ultimaMaquina;
  String _mensaje = 'Elige tu jugada';

  void _jugar(Jugada jugada) {
    final maquina = Jugada.values[_azar.nextInt(Jugada.values.length)];
    final resultado = resultadoPpt(jugada, maquina);
    setState(() {
      _ultimaTuya = jugada;
      _ultimaMaquina = maquina;
      if (resultado == 1) {
        _tu++;
        _racha++;
        _mensaje = '¡Ganas! ${jugada.nombre} gana a ${maquina.nombre.toLowerCase()}';
      } else if (resultado == -1) {
        _maquina++;
        _racha = 0;
        _mensaje = 'Pierdes: ${maquina.nombre} gana a ${jugada.nombre.toLowerCase()}';
      } else {
        _mensaje = 'Empate';
      }
    });
    if (resultado == 1 && Records.guardar(widget.juego, _racha)) {
      avisarRecord(context, widget.juego, _racha);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.juego.color;
    return Column(
      children: [
        FilaMarcadores(
          children: [
            Marcador(etiqueta: 'Tú', valor: '$_tu', color: ArcadeColores.cian),
            Marcador(etiqueta: 'Máquina', valor: '$_maquina', color: ArcadeColores.rosa),
            Marcador(etiqueta: 'Racha', valor: '$_racha', color: ArcadeColores.amarillo),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Mano(titulo: 'Tú', jugada: _ultimaTuya, color: ArcadeColores.cian),
            const Text('VS', style: TextStyle(color: ArcadeColores.textoSuave, fontSize: 22, fontWeight: FontWeight.w900)),
            _Mano(titulo: 'Máquina', jugada: _ultimaMaquina, color: ArcadeColores.rosa),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          _mensaje,
          key: const ValueKey('mensaje'),
          textAlign: TextAlign.center,
          style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        Row(
          children: [
            for (final jugada in Jugada.values)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: OutlinedButton(
                    key: ValueKey('jugada-${jugada.name}'),
                    onPressed: () => _jugar(jugada),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 84),
                      side: BorderSide(color: color, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(jugada.emoji, style: const TextStyle(fontSize: 30)),
                        Text(jugada.nombre, style: const TextStyle(color: ArcadeColores.texto, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Mano extends StatelessWidget {
  const _Mano({required this.titulo, required this.jugada, required this.color});

  final String titulo;
  final Jugada? jugada;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 104,
          height: 104,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 3),
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 20)],
          ),
          child: Text(jugada?.emoji ?? '?', style: const TextStyle(fontSize: 48, color: ArcadeColores.texto)),
        ),
        const SizedBox(height: 8),
        Text(titulo, style: TextStyle(color: color, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
