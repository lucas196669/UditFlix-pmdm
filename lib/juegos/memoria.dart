import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../data/records.dart';
import '../models/contenido.dart';
import '../theme/arcade_theme.dart';
import '../widgets/aviso_record.dart';
import '../widgets/marcador.dart';

class Memoria extends StatefulWidget {
  const Memoria({super.key, required this.juego, this.azar});

  final Contenido juego;
  final Random? azar;

  @override
  State<Memoria> createState() => _MemoriaState();
}

class _MemoriaState extends State<Memoria> {
  static const List<IconData> _iconos = [
    Icons.rocket_launch,
    Icons.star,
    Icons.favorite,
    Icons.bolt,
    Icons.pets,
    Icons.music_note,
    Icons.sports_soccer,
    Icons.diamond,
  ];

  late final Random _azar = widget.azar ?? Random();
  late List<IconData> _cartas;
  final Set<int> _encontradas = {};
  final List<int> _abiertas = [];
  int _movimientos = 0;

  /// Espera antes de volver a tapar dos cartas distintas.
  Timer? _espera;

  bool get _terminada => _encontradas.length == _cartas.length;

  @override
  void initState() {
    super.initState();
    _barajar();
  }

  @override
  void dispose() {
    _espera?.cancel();
    super.dispose();
  }

  void _barajar() {
    _espera?.cancel();
    _espera = null;
    _cartas = [..._iconos, ..._iconos]..shuffle(_azar);
    _encontradas.clear();
    _abiertas.clear();
    _movimientos = 0;
  }

  void _tocar(int indice) {
    if (_espera != null || _abiertas.contains(indice) || _encontradas.contains(indice)) return;
    setState(() => _abiertas.add(indice));
    if (_abiertas.length < 2) return;

    setState(() => _movimientos++);
    final primera = _abiertas[0];
    final segunda = _abiertas[1];
    if (_cartas[primera] == _cartas[segunda]) {
      setState(() {
        _encontradas.addAll(_abiertas);
        _abiertas.clear();
      });
      if (_terminada && Records.guardar(widget.juego, _movimientos)) {
        avisarRecord(context, widget.juego, _movimientos);
      }
    } else {
      _espera = Timer(const Duration(milliseconds: 700), () {
        setState(() {
          _abiertas.clear();
          _espera = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.juego.color;
    return Column(
      children: [
        FilaMarcadores(
          children: [
            Marcador(etiqueta: 'Movimientos', valor: '$_movimientos', color: color),
            Marcador(etiqueta: 'Parejas', valor: '${_encontradas.length ~/ 2} / ${_iconos.length}', color: ArcadeColores.verde),
          ],
        ),
        const SizedBox(height: 12),
        if (_terminada)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '¡Completado en $_movimientos movimientos!',
              key: const ValueKey('completado'),
              style: const TextStyle(color: ArcadeColores.verde, fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i < _cartas.length; i++)
                    _Carta(
                      key: ValueKey('carta-$i'),
                      icono: _cartas[i],
                      visible: _abiertas.contains(i) || _encontradas.contains(i),
                      encontrada: _encontradas.contains(i),
                      color: color,
                      alTocar: () => _tocar(i),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => setState(_barajar),
          icon: const Icon(Icons.shuffle),
          label: const Text('BARAJAR DE NUEVO'),
        ),
      ],
    );
  }
}

class _Carta extends StatelessWidget {
  const _Carta({
    super.key,
    required this.icono,
    required this.visible,
    required this.encontrada,
    required this.color,
    required this.alTocar,
  });

  final IconData icono;
  final bool visible;
  final bool encontrada;
  final Color color;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alTocar,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: visible ? ArcadeColores.tarjeta : null,
          gradient: visible ? null : const LinearGradient(colors: [ArcadeColores.morado, ArcadeColores.rosa]),
          border: Border.all(color: encontrada ? ArcadeColores.verde : color.withValues(alpha: 0.5), width: 2),
        ),
        child: Center(
          child: visible
              ? Icon(icono, color: encontrada ? ArcadeColores.verde : color, size: 30)
              : const Text('?', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}
