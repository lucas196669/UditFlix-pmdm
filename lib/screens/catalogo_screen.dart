import 'package:flutter/material.dart';

import '../arcade/arcade_screen.dart';
import '../data/contenidos.dart';
import '../models/contenido.dart';
import '../theme/app_theme.dart';
import '../widgets/imagen_contenido.dart';
import 'ficha_screen.dart';

/// Pantalla principal: catálogo de películas y series de UDITflix.
class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  void _abrirFicha(BuildContext context, Contenido contenido) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FichaScreen(contenido: contenido)),
    );
  }

  void _abrirArcade(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ArcadeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UDITflix'),
        actions: [
          IconButton(
            tooltip: 'UDIT Arcade',
            icon: const Icon(Icons.sports_esports_rounded),
            onPressed: () => _abrirArcade(context),
          ),
        ],
      ),

      // ListView.builder del catálogo principal.
      // - itemCount: número de elementos que tendrá la lista. Es el total de
      //   contenidos almacenados + 1, porque la posición 0 es la cabecera
      //   (destacados, filas por género y acceso a UDIT Arcade).
      // - itemBuilder: Flutter lo llama SOLO para los elementos que van a verse
      //   en pantalla (construcción perezosa), por eso es eficiente con listas
      //   largas. Recibe el índice y devuelve el widget de esa posición.
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: contenidos.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _Cabecera(
              onContenido: (c) => _abrirFicha(context, c),
              onArcade: () => _abrirArcade(context),
            );
          }
          // Restamos 1 porque el índice 0 lo ocupa la cabecera.
          final contenido = contenidos[index - 1];
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TarjetaContenido(
              key: ValueKey(contenido.id),
              contenido: contenido,
              onTap: () => _abrirFicha(context, contenido),
            ),
          );
        },
      ),
    );
  }
}

/// Cabecera del catálogo: destacados, acceso a UDIT Arcade y filas por género.
class _Cabecera extends StatelessWidget {
  final ValueChanged<Contenido> onContenido;
  final VoidCallback onArcade;

  const _Cabecera({required this.onContenido, required this.onArcade});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final destacados = contenidosDestacados;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carrusel de destacados.
        SizedBox(
          height: 220,
          // ListView.builder horizontal: recorre solo los contenidos destacados.
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: destacados.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _BannerDestacado(
                contenido: destacados[index],
                onTap: () => onContenido(destacados[index]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _BotonArcade(onTap: onArcade),
        ),

        // Una fila horizontal por cada género.
        for (final genero in generos) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
            child: Text(genero, style: textos.titleLarge),
          ),
          SizedBox(
            height: 190,
            // ListView.builder con scrollDirection: Axis.horizontal.
            // itemCount = contenidos de ese género; itemBuilder crea cada póster.
            child: Builder(builder: (context) {
              final lista = contenidosPorGenero(genero);
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: lista.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _Poster(
                    contenido: lista[index],
                    onTap: () => onContenido(lista[index]),
                  ),
                ),
              );
            }),
          ),
        ],

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
          child: Text('Todo el catálogo', style: textos.titleLarge),
        ),
      ],
    );
  }
}

class _BannerDestacado extends StatelessWidget {
  final Contenido contenido;
  final VoidCallback onTap;

  const _BannerDestacado({required this.contenido, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final ancho = MediaQuery.sizeOf(context).width - 48;

    return SizedBox(
      width: ancho.clamp(260, 520),
      child: Card(
        child: InkWell(
          onTap: onTap,
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
                    stops: [0.35, 1],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESTACADO',
                      style: textos.labelSmall?.copyWith(
                        color: AppTheme.moradoClaro,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(contenido.titulo, style: textos.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      '${contenido.tipo} · ${contenido.genero} · ${contenido.anio}',
                      style: textos.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonArcade extends StatelessWidget {
  final VoidCallback onTap;

  const _BotonArcade({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Card(
      color: AppTheme.morado,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.sports_esports_rounded, size: 32),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('UDIT Arcade', style: textos.titleMedium),
                    Text(
                      'Esquiva las tiras de película con tu palomita',
                      style: textos.bodyMedium?.copyWith(color: AppTheme.texto),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final Contenido contenido;
  final VoidCallback onTap;

  const _Poster({required this.contenido, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImagenContenido(contenido: contenido),
              Positioned(
                top: 6,
                right: 6,
                child: _Valoracion(valor: contenido.valoracion),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tarjeta de un contenido en la lista principal: imagen + toda su información.
class TarjetaContenido extends StatelessWidget {
  final Contenido contenido;
  final VoidCallback onTap;

  const TarjetaContenido({super.key, required this.contenido, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: 100, child: ImagenContenido(contenido: contenido)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contenido.titulo,
                        style: textos.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          Chip(
                            avatar: Icon(
                              contenido.esPelicula ? Icons.movie_rounded : Icons.live_tv_rounded,
                              size: 16,
                            ),
                            label: Text(contenido.tipo),
                            visualDensity: VisualDensity.compact,
                          ),
                          Chip(
                            label: Text(contenido.genero),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          _Valoracion(valor: contenido.valoracion),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${contenido.anio} · ${contenido.duracion}',
                              style: textos.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppTheme.textoSecundario),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Valoracion extends StatelessWidget {
  final double valor;

  const _Valoracion({required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.fondo.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 14, color: AppTheme.valoracion),
          const SizedBox(width: 2),
          Text(
            valor.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.texto),
          ),
        ],
      ),
    );
  }
}
