import 'package:flutter/material.dart';

import '../data/contenidos.dart';
import '../data/records.dart';
import '../theme/arcade_theme.dart';
import '../widgets/tarjeta_juego.dart';
import 'ficha_screen.dart';

/// Catálogo de minijuegos construido con ListView.builder.
///
/// La primera fila es la cabecera y el resto, una tarjeta por cada contenido.
/// Con ValueListenableBuilder las tarjetas muestran el récord al momento.
class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.sports_esports, color: ArcadeColores.cian),
            SizedBox(width: 10),
            Text('UDITflix Arcade', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
      body: FondoArcade(
        child: ValueListenableBuilder<Map<String, int>>(
          valueListenable: Records.mejores,
          builder: (context, records, _) {
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: contenidos.length + 1,
              itemBuilder: (context, indice) {
                if (indice == 0) {
                  return _Cabecera(total: contenidos.length, conRecord: records.length);
                }
                final juego = contenidos[indice - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TarjetaJuego(
                    key: ValueKey(juego.id),
                    juego: juego,
                    record: records[juego.id],
                    alPulsar: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (context) => FichaScreen(juego: juego)),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Cabecera extends StatelessWidget {
  const _Cabecera({required this.total, required this.conRecord});

  final int total;
  final int conRecord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Elige un minijuego',
            style: TextStyle(color: ArcadeColores.texto, fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            '$total minijuegos · $conRecord con récord',
            style: const TextStyle(color: ArcadeColores.cian, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
