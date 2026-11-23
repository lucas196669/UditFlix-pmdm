import 'dart:math';

import 'package:flutter/material.dart';

import '../data/records.dart';
import '../models/contenido.dart';
import '../theme/arcade_theme.dart';
import '../widgets/aviso_record.dart';
import '../widgets/marcador.dart';

/// Pista para [intento] cuando el número secreto es [secreto].
String pistaNumero(int intento, int secreto) {
  if (intento < secreto) return 'Más alto';
  if (intento > secreto) return 'Más bajo';
  return '¡Correcto!';
}

class AdivinaNumero extends StatefulWidget {
  const AdivinaNumero({super.key, required this.juego, this.azar});

  final Contenido juego;
  final Random? azar;

  @override
  State<AdivinaNumero> createState() => _AdivinaNumeroState();
}

class _AdivinaNumeroState extends State<AdivinaNumero> {
  late final Random _azar = widget.azar ?? Random();
  final TextEditingController _controlador = TextEditingController();
  final List<int> _historial = [];
  late int _secreto;
  int _intentos = 0;
  bool _acertado = false;
  String _pista = 'Estoy pensando un número del 1 al 100';

  @override
  void initState() {
    super.initState();
    _secreto = _azar.nextInt(100) + 1;
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  void _probar() {
    final numero = int.tryParse(_controlador.text.trim());
    if (numero == null || numero < 1 || numero > 100) {
      setState(() => _pista = 'Escribe un número del 1 al 100');
      return;
    }
    setState(() {
      _intentos++;
      _historial.insert(0, numero);
      _pista = pistaNumero(numero, _secreto);
      _acertado = numero == _secreto;
      _controlador.clear();
    });
    if (_acertado && Records.guardar(widget.juego, _intentos)) {
      avisarRecord(context, widget.juego, _intentos);
    }
  }

  void _nuevaPartida() {
    setState(() {
      _secreto = _azar.nextInt(100) + 1;
      _intentos = 0;
      _historial.clear();
      _acertado = false;
      _pista = 'Estoy pensando otro número del 1 al 100';
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.juego.color;
    return ListView(
      children: [
        FilaMarcadores(
          children: [
            Marcador(etiqueta: 'Intentos', valor: '$_intentos', color: color),
            Marcador(
              etiqueta: 'Récord',
              valor: '${Records.de(widget.juego.id) ?? '-'}',
              color: ArcadeColores.amarillo,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Icon(
          _acertado ? Icons.celebration : Icons.psychology_outlined,
          size: 72,
          color: _acertado ? ArcadeColores.verde : color,
        ),
        const SizedBox(height: 12),
        Text(
          _pista,
          key: const ValueKey('pista'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _acertado ? ArcadeColores.verde : ArcadeColores.texto,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 24),
        if (!_acertado) ...[
          TextField(
            key: const ValueKey('numero'),
            controller: _controlador,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: ArcadeColores.texto),
            decoration: InputDecoration(
              hintText: '1 - 100',
              filled: true,
              fillColor: ArcadeColores.tarjeta,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: color, width: 2),
              ),
            ),
            onSubmitted: (_) => _probar(),
          ),
          const SizedBox(height: 14),
          FilledButton(
            key: const ValueKey('probar'),
            onPressed: _probar,
            style: FilledButton.styleFrom(backgroundColor: color, foregroundColor: Colors.black),
            child: const Text('PROBAR'),
          ),
        ] else
          FilledButton(
            onPressed: _nuevaPartida,
            child: const Text('JUGAR OTRA VEZ'),
          ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            for (final numero in _historial)
              Chip(
                avatar: Icon(
                  numero < _secreto
                      ? Icons.arrow_upward
                      : numero > _secreto
                          ? Icons.arrow_downward
                          : Icons.check,
                  size: 18,
                  color: color,
                ),
                label: Text('$numero'),
              ),
          ],
        ),
      ],
    );
  }
}
