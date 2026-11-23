import 'package:flutter/material.dart';

import '../models/contenido.dart';
import '../theme/arcade_theme.dart';

/// Contenidos almacenados en la app: los minijuegos del catálogo.
const List<Contenido> contenidos = [
  Contenido(
    id: 'ppt',
    titulo: 'Piedra, papel o tijera',
    categoria: 'Azar',
    descripcion: 'El clásico contra la máquina. ¿Cuántas veces seguidas eres capaz de ganar?',
    instrucciones: [
      'Elige piedra, papel o tijera.',
      'La piedra gana a la tijera, la tijera al papel y el papel a la piedra.',
      'El récord es tu mejor racha de victorias seguidas.',
    ],
    icono: Icons.back_hand_outlined,
    color: ArcadeColores.rosa,
    dificultad: 1,
    tipoRecord: TipoRecord.masEsMejor,
    unidadRecord: 'victorias seguidas',
  ),
  Contenido(
    id: 'adivina',
    titulo: 'Adivina el número',
    categoria: 'Lógica',
    descripcion: 'La máquina piensa un número del 1 al 100. Te dice si es más alto o más bajo.',
    instrucciones: [
      'Escribe un número del 1 al 100 y pulsa Probar.',
      'Sigue las pistas: "Más alto" o "Más bajo".',
      'El récord es acertarlo en el menor número de intentos.',
    ],
    icono: Icons.psychology_outlined,
    color: ArcadeColores.cian,
    dificultad: 1,
    tipoRecord: TipoRecord.menosEsMejor,
    unidadRecord: 'intentos',
  ),
  Contenido(
    id: 'tres-en-raya',
    titulo: 'Tres en raya',
    categoria: 'Lógica',
    descripcion: 'Tú eres la X y la máquina la O. La máquina sabe ganar y bloquearte.',
    instrucciones: [
      'Toca una casilla libre para poner tu X.',
      'La máquina responde con su O.',
      'Gana quien haga tres en línea. El récord son tus victorias.',
    ],
    icono: Icons.grid_3x3,
    color: ArcadeColores.verde,
    dificultad: 2,
    tipoRecord: TipoRecord.masEsMejor,
    unidadRecord: 'victorias',
  ),
  Contenido(
    id: 'reflejos',
    titulo: 'Reflejos',
    categoria: 'Habilidad',
    descripcion: 'Una diana aparece y cambia de sitio. Tócala tantas veces como puedas en 20 segundos.',
    instrucciones: [
      'Pulsa Empezar.',
      'Toca la diana: cada vez que la tocas, salta a otro sitio.',
      'El récord son los toques en 20 segundos.',
    ],
    icono: Icons.ads_click,
    color: ArcadeColores.naranja,
    dificultad: 2,
    tipoRecord: TipoRecord.masEsMejor,
    unidadRecord: 'toques',
  ),
  Contenido(
    id: 'memoria',
    titulo: 'Memoria',
    categoria: 'Memoria',
    descripcion: 'Dieciséis cartas boca abajo y ocho parejas de iconos. Encuéntralas todas.',
    instrucciones: [
      'Toca dos cartas para darles la vuelta.',
      'Si son iguales se quedan descubiertas; si no, se vuelven a tapar.',
      'El récord es terminar en el menor número de movimientos.',
    ],
    icono: Icons.style_outlined,
    color: ArcadeColores.amarillo,
    dificultad: 3,
    tipoRecord: TipoRecord.menosEsMejor,
    unidadRecord: 'movimientos',
  ),
];
