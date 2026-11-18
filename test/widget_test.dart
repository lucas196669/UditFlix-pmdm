import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uditflix/arcade/udit_arcade_game.dart';
import 'package:uditflix/data/contenidos.dart';
import 'package:uditflix/main.dart';
import 'package:uditflix/models/contenido.dart';
import 'package:uditflix/screens/catalogo_screen.dart';

void main() {
  testWidgets('La app arranca y muestra el catálogo', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('UDITflix'), findsOneWidget);
    expect(find.text('UDIT Arcade'), findsOneWidget);
    expect(find.byIcon(Icons.sports_esports_rounded), findsWidgets);

    // El catálogo principal es un ListView.builder: bajamos hasta la lista
    // y comprobamos que aparece una tarjeta con la información del contenido.
    final primeraTarjeta = find.byKey(ValueKey(contenidos.first.id));
    await tester.scrollUntilVisible(
      primeraTarjeta,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(primeraTarjeta, findsOneWidget);
    expect(find.byType(TarjetaContenido), findsWidgets);
    expect(
      find.descendant(of: primeraTarjeta, matching: find.text(contenidos.first.titulo)),
      findsWidgets, // título de la tarjeta + placeholder de la imagen (sin red en tests)
    );
    expect(
      find.descendant(of: primeraTarjeta, matching: find.text(contenidos.first.genero)),
      findsOneWidget,
    );
  });

  group('Modelo Contenido', () {
    test('sin videoUrl usa el vídeo de demostración', () {
      const c = Contenido(
        id: 't1',
        titulo: 'Prueba',
        tipo: 'Serie',
        genero: 'Drama',
        anio: 2024,
        duracion: '1 temporada',
        valoracion: 7.5,
        descripcion: 'Descripción',
        imagenUrl: 'https://example.com/a.jpg',
      );
      expect(c.videoUrl, isNull);
      expect(c.videoParaReproducir, videoDemoPorDefecto);
      expect(c.esPelicula, isFalse);
      expect(c.destacado, isFalse);
    });

    test('con videoUrl usa su propio vídeo', () {
      const url = 'https://example.com/video.mp4';
      const c = Contenido(
        id: 't2',
        titulo: 'Otra',
        tipo: 'Película',
        genero: 'Comedia',
        anio: 2020,
        duracion: '1h 30min',
        valoracion: 6,
        descripcion: 'Descripción',
        imagenUrl: 'https://example.com/b.jpg',
        videoUrl: url,
      );
      expect(c.videoParaReproducir, url);
      expect(c.esPelicula, isTrue);
    });

    test('los datos del catálogo son válidos', () {
      expect(contenidos, isNotEmpty);
      expect(contenidos.map((c) => c.id).toSet().length, contenidos.length);
      expect(contenidosDestacados, isNotEmpty);
      for (final c in contenidos) {
        expect(c.valoracion, inInclusiveRange(0, 10));
      }
    });
  });

  group('UDIT Arcade', () {
    test('la puntuación empieza en 0 y el juego en la pantalla de inicio', () {
      final juego = UditArcadeGame();
      expect(juego.puntuacion, 0);
      expect(juego.estado, EstadoJuego.inicio);
    });

    test('sumarPunto suma 1 y actualiza el récord de la sesión', () {
      final juego = UditArcadeGame();
      juego.sumarPunto();
      juego.sumarPunto();
      expect(juego.puntuacion, 2);
      expect(juego.mejorRecord, greaterThanOrEqualTo(2));
    });
  });
}
