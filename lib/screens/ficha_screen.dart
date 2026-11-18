import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../theme/app_theme.dart';
import '../widgets/imagen_contenido.dart';
import 'player_screen.dart';

/// Ficha de detalle de un contenido, con el botón "Reproducir".
class FichaScreen extends StatelessWidget {
  final Contenido contenido;

  const FichaScreen({super.key, required this.contenido});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(contenido.titulo)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ImagenContenido(contenido: contenido),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppTheme.fondo],
                      stops: [0.5, 1],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contenido.titulo, style: textos.headlineLarge),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      avatar: Icon(
                        contenido.esPelicula ? Icons.movie_rounded : Icons.live_tv_rounded,
                        size: 16,
                      ),
                      label: Text(contenido.tipo),
                    ),
                    Chip(label: Text(contenido.genero)),
                    Chip(label: Text('${contenido.anio}')),
                    Chip(
                      avatar: const Icon(Icons.schedule_rounded, size: 16),
                      label: Text(contenido.duracion),
                    ),
                    Chip(
                      avatar: const Icon(Icons.star_rounded, size: 16, color: AppTheme.valoracion),
                      label: Text(contenido.valoracion.toStringAsFixed(1)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Botón "Reproducir": navega al reproductor con Navigator.push.
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Reproducir'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(contenido: contenido),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Sinopsis', style: textos.titleMedium),
                const SizedBox(height: 6),
                Text(contenido.descripcion, style: textos.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
