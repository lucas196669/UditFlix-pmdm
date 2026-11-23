import 'package:flutter_test/flutter_test.dart';
import 'package:uditflix/data/contenidos.dart';
import 'package:uditflix/data/records.dart';
import 'package:uditflix/models/contenido.dart';

void main() {
  group('Contenidos del catálogo', () {
    test('hay cinco minijuegos con id distinto', () {
      expect(contenidos.length, 5);
      expect(contenidos.map((c) => c.id).toSet().length, contenidos.length);
    });

    test('cada minijuego tiene instrucciones y una dificultad de 1 a 3', () {
      for (final juego in contenidos) {
        expect(juego.instrucciones, isNotEmpty, reason: juego.titulo);
        expect(juego.dificultad, inInclusiveRange(1, 3), reason: juego.titulo);
        expect(juego.descripcion.trim(), isNotEmpty);
      }
    });
  });

  group('Récords', () {
    setUp(Records.reiniciar);

    Contenido juego(String id) => contenidos.firstWhere((c) => c.id == id);

    test('si más es mejor, solo guarda puntuaciones mayores', () {
      final reflejos = juego('reflejos');
      expect(Records.guardar(reflejos, 10), isTrue);
      expect(Records.guardar(reflejos, 8), isFalse);
      expect(Records.guardar(reflejos, 12), isTrue);
      expect(Records.de('reflejos'), 12);
    });

    test('si menos es mejor, solo guarda puntuaciones menores', () {
      final adivina = juego('adivina');
      expect(Records.guardar(adivina, 7), isTrue);
      expect(Records.guardar(adivina, 9), isFalse);
      expect(Records.guardar(adivina, 4), isTrue);
      expect(Records.de('adivina'), 4);
    });

    test('cero puntos no es récord cuando más es mejor', () {
      expect(Records.guardar(juego('reflejos'), 0), isFalse);
      expect(Records.de('reflejos'), isNull);
    });
  });
}
