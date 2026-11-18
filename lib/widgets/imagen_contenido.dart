import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../theme/app_theme.dart';

/// Imagen de Internet de un contenido. Mientras carga o si falla se muestra
/// un placeholder con el título: nunca aparece un error en pantalla.
class ImagenContenido extends StatelessWidget {
  final Contenido contenido;
  final BoxFit fit;

  const ImagenContenido({
    super.key,
    required this.contenido,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      contenido.imagenUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      // loadingBuilder: mientras se descarga, placeholder con spinner.
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) return child;
        return _Placeholder(titulo: contenido.titulo, cargando: true);
      },
      // errorBuilder: si la imagen no carga, placeholder con el título.
      errorBuilder: (context, error, stackTrace) =>
          _Placeholder(titulo: contenido.titulo),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final String titulo;
  final bool cargando;

  const _Placeholder({required this.titulo, this.cargando = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.morado, AppTheme.superficie],
        ),
      ),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          cargando
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.movie_rounded, color: AppTheme.textoSecundario),
          const SizedBox(height: 8),
          Text(
            titulo,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
