import '../models/contenido.dart';

/// Contenidos almacenados en la app. El catálogo los recorre con ListView.builder.
/// Las imágenes vienen de Internet (picsum.photos) y algunos contenidos
/// tienen videoUrl propio; los demás usan el vídeo de demostración.
const List<Contenido> contenidos = [
  Contenido(
    id: 'c1',
    titulo: 'Código Nocturno',
    tipo: 'Película',
    genero: 'Thriller',
    anio: 2024,
    duracion: '1h 58min',
    valoracion: 8.4,
    descripcion:
        'Una programadora descubre una línea de código que no debería existir y '
        'tiene una noche para averiguar quién la escribió.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-codigo/400/600',
    destacado: true,
    videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ),
  Contenido(
    id: 'c2',
    titulo: 'Campus Infinito',
    tipo: 'Serie',
    genero: 'Comedia',
    anio: 2023,
    duracion: '2 temporadas',
    valoracion: 7.9,
    descripcion:
        'Cinco estudiantes de diseño intentan sobrevivir al último curso '
        'mientras montan la startup más caótica de Madrid.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-campus/400/600',
    videoUrl:
        'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
  ),
  Contenido(
    id: 'c3',
    titulo: 'Horizonte Rojo',
    tipo: 'Película',
    genero: 'Ciencia ficción',
    anio: 2025,
    duracion: '2h 14min',
    valoracion: 8.8,
    descripcion:
        'La primera colonia de Marte pierde el contacto con la Tierra. '
        'Nadie sabe si el silencio es una avería o un aviso.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-horizonte/400/600',
    destacado: true,
  ),
  Contenido(
    id: 'c4',
    titulo: 'La Última Toma',
    tipo: 'Película',
    genero: 'Drama',
    anio: 2022,
    duracion: '1h 46min',
    valoracion: 7.6,
    descripcion:
        'Un director veterano rueda su última película con un equipo de '
        'estudiantes que no saben que es su despedida.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-toma/400/600',
  ),
  Contenido(
    id: 'c5',
    titulo: 'Píxeles Perdidos',
    tipo: 'Serie',
    genero: 'Animación',
    anio: 2024,
    duracion: '1 temporada',
    valoracion: 8.1,
    descripcion:
        'Los personajes de un videojuego olvidado escapan del cartucho y '
        'buscan un nuevo jugador antes de borrarse para siempre.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-pixeles/400/600',
    destacado: true,
  ),
  Contenido(
    id: 'c6',
    titulo: 'Sombras en Lavapiés',
    tipo: 'Serie',
    genero: 'Thriller',
    anio: 2021,
    duracion: '3 temporadas',
    valoracion: 8.3,
    descripcion:
        'Una inspectora recién llegada a Madrid investiga desapariciones que '
        'siempre ocurren la noche de luna llena.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-sombras/400/600',
  ),
  Contenido(
    id: 'c7',
    titulo: 'Órbita Cero',
    tipo: 'Serie',
    genero: 'Ciencia ficción',
    anio: 2025,
    duracion: '1 temporada',
    valoracion: 7.7,
    descripcion:
        'La tripulación de una estación espacial despierta sin recuerdos y '
        'con un mensaje grabado por ellos mismos.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-orbita/400/600',
  ),
  Contenido(
    id: 'c8',
    titulo: 'Risas en Directo',
    tipo: 'Película',
    genero: 'Comedia',
    anio: 2023,
    duracion: '1h 32min',
    valoracion: 6.9,
    descripcion:
        'Un programa de televisión en directo se descontrola cuando el '
        'presentador se queda encerrado en el ascensor del plató.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-risas/400/600',
  ),
  Contenido(
    id: 'c9',
    titulo: 'El Faro del Norte',
    tipo: 'Película',
    genero: 'Drama',
    anio: 2020,
    duracion: '2h 03min',
    valoracion: 8.0,
    descripcion:
        'Dos hermanos que no se hablan desde hace diez años heredan el faro '
        'donde crecieron y deben decidir qué hacer con él.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-faro/400/600',
  ),
  Contenido(
    id: 'c10',
    titulo: 'Bosque de Papel',
    tipo: 'Película',
    genero: 'Animación',
    anio: 2022,
    duracion: '1h 28min',
    valoracion: 7.4,
    descripcion:
        'Una niña dibuja un bosque en su cuaderno y, al día siguiente, '
        'aparece en el patio del colegio.',
    imagenUrl: 'https://picsum.photos/seed/uditflix-bosque/400/600',
  ),
];

/// Contenidos marcados como destacados (banner principal).
List<Contenido> get contenidosDestacados =>
    contenidos.where((c) => c.destacado).toList();

/// Géneros distintos, en el orden en el que aparecen en [contenidos].
List<String> get generos =>
    contenidos.map((c) => c.genero).toSet().toList();

/// Contenidos de un género concreto (para las filas horizontales).
List<Contenido> contenidosPorGenero(String genero) =>
    contenidos.where((c) => c.genero == genero).toList();
