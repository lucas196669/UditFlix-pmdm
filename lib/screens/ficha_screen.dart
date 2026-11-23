import 'package:flutter/material.dart';

import '../data/records.dart';
import '../models/contenido.dart';
import '../theme/arcade_theme.dart';
import '../widgets/estrellas_dificultad.dart';
import 'reproductor_screen.dart';

/// Ficha de un minijuego: qué es, cómo se juega, récord y botón de jugar.
class FichaScreen extends StatelessWidget {
  const FichaScreen({super.key, required this.juego});

  final Contenido juego;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(juego.titulo)),
      body: FondoArcade(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: juego.color.withValues(alpha: 0.15),
                  border: Border.all(color: juego.color, width: 3),
                  boxShadow: [BoxShadow(color: juego.color.withValues(alpha: 0.5), blurRadius: 32)],
                ),
                child: Icon(juego.icono, size: 60, color: juego.color),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              juego.titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(color: ArcadeColores.texto, fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  juego.categoria.toUpperCase(),
                  style: TextStyle(color: juego.color, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                ),
                const SizedBox(width: 10),
                EstrellasDificultad(nivel: juego.dificultad, tamano: 20),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              juego.descripcion,
              textAlign: TextAlign.center,
              style: const TextStyle(color: ArcadeColores.textoSuave, fontSize: 16, height: 1.45),
            ),
            const SizedBox(height: 24),
            const Text(
              'CÓMO SE JUEGA',
              style: TextStyle(color: ArcadeColores.texto, fontWeight: FontWeight.w900, letterSpacing: 1.5),
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < juego.instrucciones.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: juego.color,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        juego.instrucciones[i],
                        style: const TextStyle(color: ArcadeColores.texto, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            ValueListenableBuilder<Map<String, int>>(
              valueListenable: Records.mejores,
              builder: (context, records, _) {
                final record = records[juego.id];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ArcadeColores.tarjeta,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ArcadeColores.amarillo.withValues(alpha: 0.6)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.emoji_events, color: ArcadeColores.amarillo, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          record == null ? 'Todavía no hay récord. ¡Sé el primero!' : 'Tu récord: $record ${juego.unidadRecord}',
                          style: const TextStyle(color: ArcadeColores.texto, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const ValueKey('jugar'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (context) => ReproductorScreen(juego: juego)),
              ),
              style: FilledButton.styleFrom(backgroundColor: juego.color, foregroundColor: Colors.black),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('JUGAR'),
            ),
          ],
        ),
      ),
    );
  }
}
