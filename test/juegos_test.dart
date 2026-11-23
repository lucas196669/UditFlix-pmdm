import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:uditflix/juegos/adivina_numero.dart';
import 'package:uditflix/juegos/piedra_papel_tijera.dart';
import 'package:uditflix/juegos/tres_en_raya.dart';

void main() {
  test('piedra, papel o tijera: quién gana', () {
    expect(resultadoPpt(Jugada.piedra, Jugada.tijera), 1);
    expect(resultadoPpt(Jugada.papel, Jugada.piedra), 1);
    expect(resultadoPpt(Jugada.tijera, Jugada.papel), 1);
    expect(resultadoPpt(Jugada.tijera, Jugada.piedra), -1);
    expect(resultadoPpt(Jugada.papel, Jugada.papel), 0);
  });

  test('adivina el número: pistas', () {
    expect(pistaNumero(20, 50), 'Más alto');
    expect(pistaNumero(80, 50), 'Más bajo');
    expect(pistaNumero(50, 50), '¡Correcto!');
  });

  group('tres en raya', () {
    test('detecta fila, columna, diagonal y empate', () {
      expect(ganadorTresEnRaya(['X', 'X', 'X', null, 'O', null, 'O', null, null]), 'X');
      expect(ganadorTresEnRaya(['O', 'X', null, 'O', 'X', null, 'O', null, null]), 'O');
      expect(ganadorTresEnRaya(['X', 'O', null, 'O', 'X', null, null, null, 'X']), 'X');
      expect(ganadorTresEnRaya(['X', 'O', 'X', 'X', 'O', 'O', 'O', 'X', 'X']), 'empate');
      expect(ganadorTresEnRaya(List<String?>.filled(9, null)), isNull);
    });

    test('la máquina gana si puede', () {
      final tablero = <String?>['O', 'O', null, 'X', 'X', null, null, null, null];
      expect(jugadaMaquina(tablero, Random(1)), 2);
    });

    test('la máquina bloquea al jugador', () {
      final tablero = <String?>['X', 'X', null, null, 'O', null, null, null, null];
      expect(jugadaMaquina(tablero, Random(1)), 2);
    });

    test('la máquina coge el centro si está libre', () {
      final tablero = <String?>['X', null, null, null, null, null, null, null, null];
      expect(jugadaMaquina(tablero, Random(1)), 4);
    });
  });
}
