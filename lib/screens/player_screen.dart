import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/contenido.dart';
import '../theme/app_theme.dart';

/// Reproductor de vídeo de UDITflix.
///
/// - video_player descarga y decodifica el vídeo (VideoPlayerController).
/// - chewie pone encima los controles ya hechos: reproducir/pausar, barra de
///   progreso, tiempo actual/total, silencio y pantalla completa.
class VideoPlayerScreen extends StatefulWidget {
  final Contenido contenido;

  const VideoPlayerScreen({super.key, required this.contenido});

  /// video_player funciona en Android, iOS, macOS y web. En Windows y Linux
  /// no hay implementación oficial, así que mostramos un aviso.
  static bool get plataformaSoportada {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS || TargetPlatform.macOS => true,
      _ => false,
    };
  }

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _cargando = true;
  String? _error;
  double _volumen = 1;

  @override
  void initState() {
    super.initState();
    if (VideoPlayerScreen.plataformaSoportada) _inicializar();
  }

  /// Crea los controladores y carga el vídeo. También se usa al pulsar "Reintentar".
  Future<void> _inicializar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    _liberarControladores();

    final video = VideoPlayerController.networkUrl(
      Uri.parse(widget.contenido.videoParaReproducir),
    );
    _videoController = video;

    try {
      await video.initialize();
      if (!mounted) return; // dispose() ya liberó el controlador
      await video.setVolume(_volumen);

      final colores = ChewieProgressColors(
        playedColor: AppTheme.moradoClaro,
        handleColor: AppTheme.moradoClaro,
        bufferedColor: AppTheme.textoSecundario.withValues(alpha: 0.5),
        backgroundColor: AppTheme.superficieAlta,
      );

      _chewieController = ChewieController(
        videoPlayerController: video,
        autoPlay: true,
        // Relación de aspecto real del vídeo (ancho / alto).
        aspectRatio: video.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        materialProgressColors: colores,
        cupertinoProgressColors: colores,
        // Si el vídeo falla durante la reproducción, chewie muestra esto.
        errorBuilder: (context, mensaje) => _VistaError(onReintentar: _inicializar),
      );
      setState(() => _cargando = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _error = 'No se ha podido cargar el vídeo. Comprueba tu conexión.';
      });
    }
  }

  /// Pausa y libera los dos controladores (chewie no libera el de video_player).
  void _liberarControladores() {
    final chewie = _chewieController;
    final video = _videoController;
    _chewieController = null;
    _videoController = null;
    chewie?.dispose();
    video?.pause();
    video?.dispose();
  }

  void _cambiarVolumen(double valor) {
    setState(() => _volumen = valor);
    _videoController?.setVolume(valor);
  }

  @override
  void dispose() {
    // Al salir de la pantalla: pausa + dispose() de VideoPlayerController y ChewieController.
    _liberarControladores();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final contenido = widget.contenido;

    return Scaffold(
      appBar: AppBar(title: Text(contenido.titulo)),
      body: ListView(
        children: [
          ColoredBox(color: Colors.black, child: _zonaVideo()),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contenido.titulo, style: textos.headlineSmall),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      contenido.esPelicula ? Icons.movie_rounded : Icons.live_tv_rounded,
                      size: 18,
                      color: AppTheme.moradoClaro,
                    ),
                    const SizedBox(width: 6),
                    Text('${contenido.anio} · ${contenido.genero}', style: textos.bodyMedium),
                  ],
                ),
                if (_chewieController != null) ...[
                  const SizedBox(height: 12),
                  // Control de volumen (0 = silencio, 1 = máximo).
                  Row(
                    children: [
                      Icon(
                        _volumen == 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                        color: AppTheme.textoSecundario,
                      ),
                      Expanded(
                        child: Slider(
                          value: _volumen,
                          onChanged: _cambiarVolumen,
                          semanticFormatterCallback: (v) => 'Volumen ${(v * 100).round()} %',
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Text(contenido.descripcion, style: textos.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _zonaVideo() {
    if (!VideoPlayerScreen.plataformaSoportada) {
      return const AspectRatio(aspectRatio: 16 / 9, child: _VistaNoSoportada());
    }
    if (_error != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: _VistaError(mensaje: _error!, onReintentar: _inicializar),
      );
    }
    final chewie = _chewieController;
    if (_cargando || chewie == null) {
      // Spinner mientras se carga el vídeo.
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    // AspectRatio con la proporción real del vídeo para que no se deforme.
    return AspectRatio(
      aspectRatio: chewie.videoPlayerController.value.aspectRatio,
      child: Chewie(controller: chewie),
    );
  }
}

class _VistaError extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _VistaError({
    this.mensaje = 'Se ha producido un error al reproducir el vídeo.',
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: AppTheme.moradoClaro),
            const SizedBox(height: 8),
            Text(mensaje, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
              onPressed: onReintentar,
            ),
          ],
        ),
      ),
    );
  }
}

class _VistaNoSoportada extends StatelessWidget {
  const _VistaNoSoportada();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_off_rounded, size: 40, color: AppTheme.moradoClaro),
            const SizedBox(height: 8),
            Text(
              'La reproducción de vídeo no está disponible en esta plataforma.\n'
              'Abre UDITflix en Android, iOS, macOS o en el navegador.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
