import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../theme/arcade_theme.dart';
import 'estrellas_dificultad.dart';

/// Tarjeta de un minijuego en el catálogo: icono de neón, título, categoría,
/// dificultad, descripción y récord.
class TarjetaJuego extends StatelessWidget {
  const TarjetaJuego({super.key, required this.juego, required this.record, required this.alPulsar});

  final Contenido juego;

  /// Mejor puntuación conseguida, o null si todavía no se ha jugado.
  final int? record;

  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ArcadeColores.tarjeta,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alPulsar,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: juego.color.withValues(alpha: 0.7), width: 1.5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: juego.color.withValues(alpha: 0.15),
                  border: Border.all(color: juego.color, width: 2),
                  boxShadow: [BoxShadow(color: juego.color.withValues(alpha: 0.45), blurRadius: 16)],
                ),
                child: Icon(juego.icono, color: juego.color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      juego.titulo,
                      style: const TextStyle(
                        color: ArcadeColores.texto,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _Etiqueta(texto: juego.categoria, color: juego.color),
                        const SizedBox(width: 8),
                        EstrellasDificultad(nivel: juego.dificultad),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      juego.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: ArcadeColores.textoSuave, height: 1.35),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 18,
                          color: record == null ? ArcadeColores.textoSuave : ArcadeColores.amarillo,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            record == null ? 'Sin récord todavía' : 'Récord: $record ${juego.unidadRecord}',
                            style: TextStyle(
                              color: record == null ? ArcadeColores.textoSuave : ArcadeColores.amarillo,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: ArcadeColores.textoSuave),
            ],
          ),
        ),
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto.toUpperCase(),
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1),
      ),
    );
  }
}
