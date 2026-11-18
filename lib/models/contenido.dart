/// Vídeo que se reproduce cuando un contenido no tiene [Contenido.videoUrl].
const String videoDemoPorDefecto =
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

/// Modelo de una película o serie del catálogo de UDITflix.
class Contenido {
  final String id;
  final String titulo;
  final String tipo; // 'Película' o 'Serie'
  final String genero;
  final int anio;
  final String duracion; // p. ej. '1h 52min' o '2 temporadas'
  final double valoracion; // de 0 a 10
  final String descripcion;
  final String imagenUrl;
  final bool destacado;

  /// Vídeo del contenido. Es opcional: si es null se usa [videoDemoPorDefecto].
  final String? videoUrl;

  const Contenido({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.genero,
    required this.anio,
    required this.duracion,
    required this.valoracion,
    required this.descripcion,
    required this.imagenUrl,
    this.destacado = false,
    this.videoUrl,
  });

  bool get esPelicula => tipo == 'Película';

  /// URL que recibe el reproductor (nunca es null).
  String get videoParaReproducir => videoUrl ?? videoDemoPorDefecto;
}
