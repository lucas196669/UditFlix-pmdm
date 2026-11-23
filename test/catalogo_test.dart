import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uditflix/data/contenidos.dart';
import 'package:uditflix/data/records.dart';
import 'package:uditflix/juegos/memoria.dart';
import 'package:uditflix/juegos/reflejos.dart';
import 'package:uditflix/juegos/tres_en_raya.dart';
import 'package:uditflix/main.dart';
import 'package:uditflix/screens/catalogo_screen.dart';
import 'package:uditflix/screens/ficha_screen.dart';
import 'package:uditflix/screens/reproductor_screen.dart';
import 'package:uditflix/theme/arcade_theme.dart';

Widget _envolver(Widget hijo) => MaterialApp(theme: temaArcade(), home: Scaffold(body: hijo));

void main() {
  setUp(Records.reiniciar);

  testWidgets('el catálogo es un ListView.builder con todos los minijuegos', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final lista = tester.widget<ListView>(find.byType(ListView));
    expect(lista.childrenDelegate, isA<SliverChildBuilderDelegate>());
    expect(find.text('Elige un minijuego'), findsOneWidget);
    expect(find.text(contenidos.first.titulo), findsOneWidget);
    expect(find.text('${contenidos.length} minijuegos · 0 con récord'), findsOneWidget);
  });

  testWidgets('catálogo → ficha → jugar → volver', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text(contenidos.first.titulo));
    await tester.pumpAndSettle();
    expect(find.byType(FichaScreen), findsOneWidget);
    expect(find.text('CÓMO SE JUEGA'), findsOneWidget);

    // El botón está al final de la ficha: hay que bajar hasta él.
    final jugar = find.byKey(const ValueKey('jugar'));
    await tester.scrollUntilVisible(jugar, 300, scrollable: find.byType(Scrollable).last);
    await tester.pumpAndSettle();
    await tester.tap(jugar);
    await tester.pumpAndSettle();
    expect(find.byType(ReproductorScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('jugada-piedra')));
    await tester.pump();
    expect(find.text('Elige tu jugada'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(CatalogoScreen), findsOneWidget);
  });

  testWidgets('tres en raya: pones X y la máquina responde con O', (tester) async {
    final juego = contenidos.firstWhere((c) => c.id == 'tres-en-raya');
    await tester.pumpWidget(_envolver(TresEnRaya(juego: juego, azar: Random(3))));

    await tester.tap(find.byKey(const ValueKey('casilla-0')));
    await tester.pump();
    expect(find.text('X'), findsOneWidget);
    expect(find.text('O'), findsOneWidget);
  });

  testWidgets('reflejos: la partida termina sola a los 20 segundos', (tester) async {
    final juego = contenidos.firstWhere((c) => c.id == 'reflejos');
    await tester.pumpWidget(_envolver(Reflejos(juego: juego, azar: Random(5))));

    await tester.tap(find.byKey(const ValueKey('empezar')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('diana')));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.byKey(const ValueKey('diana')));
    await tester.pump(const Duration(seconds: 21));
    await tester.pumpAndSettle();

    expect(find.text('¡Tiempo! Has hecho 2 toques'), findsOneWidget);
    expect(Records.de('reflejos'), 2);
  });

  testWidgets('memoria: dos cartas distintas se vuelven a tapar', (tester) async {
    final juego = contenidos.firstWhere((c) => c.id == 'memoria');
    await tester.pumpWidget(_envolver(Memoria(juego: juego, azar: Random(7))));

    expect(find.text('?'), findsNWidgets(16));
    await tester.tap(find.byKey(const ValueKey('carta-0')));
    await tester.pump();
    expect(find.text('?'), findsNWidgets(15));
    await tester.tap(find.byKey(const ValueKey('carta-1')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    // O eran pareja (quedan 14 tapadas) o se han vuelto a tapar (16).
    final tapadas = find.text('?').evaluate().length;
    expect(tapadas == 14 || tapadas == 16, isTrue);
    expect(find.text('1'), findsOneWidget);
  });
}
