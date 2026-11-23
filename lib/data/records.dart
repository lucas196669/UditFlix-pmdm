import 'package:flutter/foundation.dart';

import '../models/contenido.dart';

/// Mejores puntuaciones de la partida actual (se pierden al cerrar la app).
///
/// Es un ValueNotifier: el catálogo y la ficha se redibujan solos cuando cambia.
class Records {
  Records._();

  static final ValueNotifier<Map<String, int>> mejores = ValueNotifier<Map<String, int>>({});

  static int? de(String id) => mejores.value[id];

  /// Guarda [puntos] si mejoran el récord de [juego]. Devuelve true si es un récord nuevo.
  static bool guardar(Contenido juego, int puntos) {
    if (juego.tipoRecord == TipoRecord.masEsMejor && puntos <= 0) return false;
    final actual = mejores.value[juego.id];
    final mejora = actual == null ||
        (juego.tipoRecord == TipoRecord.masEsMejor ? puntos > actual : puntos < actual);
    if (mejora) {
      mejores.value = {...mejores.value, juego.id: puntos};
    }
    return mejora;
  }

  static void reiniciar() => mejores.value = {};
}
