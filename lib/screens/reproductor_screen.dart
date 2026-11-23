import 'package:flutter/material.dart';

import '../juegos/adivina_numero.dart';
import '../juegos/memoria.dart';
import '../juegos/piedra_papel_tijera.dart';
import '../juegos/reflejos.dart';
import '../juegos/tres_en_raya.dart';
import '../models/contenido.dart';
import '../theme/arcade_theme.dart';

/// Pantalla donde se juega: carga el minijuego que corresponde al contenido.
class ReproductorScreen extends StatelessWidget {
  const ReproductorScreen({super.key, required this.juego});

  final Contenido juego;

  Widget _minijuego() {
    switch (juego.id) {
      case 'ppt':
        return PiedraPapelTijera(juego: juego);
      case 'adivina':
        return AdivinaNumero(juego: juego);
      case 'tres-en-raya':
        return TresEnRaya(juego: juego);
      case 'reflejos':
        return Reflejos(juego: juego);
      case 'memoria':
        return Memoria(juego: juego);
      default:
        return const Center(child: Text('Minijuego no disponible'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(juego.icono, color: juego.color),
            const SizedBox(width: 10),
            Flexible(child: Text(juego.titulo, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
      body: FondoArcade(
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _minijuego(),
          ),
        ),
      ),
    );
  }
}
