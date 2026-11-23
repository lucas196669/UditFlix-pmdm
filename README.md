# UDITflix Arcade 🎮

Actividad de PMDM: continuación de la demo de clase de **UDITflix** con Flutter.
El catálogo de contenidos se construye con **`ListView.builder`**, muestra la información de cada contenido y la interfaz tiene **colores, iconos y estilos propios**.
Los contenidos de esta versión son **minijuegos que se pueden jugar**.

> Rama `mejoras`. La rama `main` contiene la demo de partida de clase.

## Cómo ejecutarla

```bash
flutter pub get
flutter run            # en un emulador o móvil Android
flutter test           # pruebas automáticas
```

## Qué hay en la app

| Pantalla | Qué hace |
|---|---|
| **Catálogo** (`catalogo_screen.dart`) | `ListView.builder` con una cabecera y una tarjeta por minijuego: icono de neón, título, categoría, dificultad (estrellas), descripción y récord |
| **Ficha** (`ficha_screen.dart`) | Icono grande, categoría, dificultad, descripción, "Cómo se juega" paso a paso, récord y botón **JUGAR** |
| **Juego** (`reproductor_screen.dart`) | Carga el minijuego elegido |

### Los 5 minijuegos

| Minijuego | Categoría | Cómo funciona | Récord |
|---|---|---|---|
| ✊ Piedra, papel o tijera | Azar | Contra la máquina, con marcador | Mejor racha de victorias seguidas |
| 🧠 Adivina el número | Lógica | Número secreto del 1 al 100 con pistas "Más alto / Más bajo" | Menos intentos |
| ❌ Tres en raya | Lógica | Tú eres la X; la máquina gana si puede, te bloquea o coge el centro | Victorias |
| 🎯 Reflejos | Habilidad | Toca la diana, que salta de sitio, durante 20 segundos | Más toques |
| 🃏 Memoria | Memoria | 16 cartas y 8 parejas de iconos | Menos movimientos |

Los récords se guardan mientras la app está abierta (`ValueNotifier`). El catálogo y la ficha se actualizan solos al batir un récord, y sale un aviso.

## ListView.builder

```dart
ListView.builder(
  itemCount: contenidos.length + 1,      // cabecera + un elemento por contenido
  itemBuilder: (context, indice) {
    if (indice == 0) return _Cabecera(...);
    final juego = contenidos[indice - 1];
    return TarjetaJuego(
      juego: juego,
      record: records[juego.id],
      alPulsar: () => Navigator.push(...FichaScreen(juego: juego)),
    );
  },
)
```

`ListView.builder` solo construye las tarjetas que se ven en pantalla. Cada tarjeta muestra los datos del `Contenido` almacenado en `lib/data/contenidos.dart`.

## Estilo propio

| | |
|---|---|
| **Colores** | Fondo morado oscuro con degradado (`#2A1252` → `#120B2E`) y un color de neón por juego: rosa `#FF4FA3`, cian `#00E5FF`, verde `#39FF88`, naranja `#FF8A3D` y amarillo `#FFD54F` |
| **Iconos** | Material Icons: uno por juego, estrellas de dificultad, trofeo de récord y botones de juego |
| **Estilos** | Tarjetas redondeadas con borde y brillo de neón (`BoxShadow`), textos en negrita, botones grandes de 54 px de alto y tema oscuro propio (`lib/theme/arcade_theme.dart`) |

## Estructura

```text
lib/
├── main.dart                       ← MaterialApp con el tema arcade
├── models/contenido.dart           ← clase Contenido (un minijuego)
├── data/
│   ├── contenidos.dart             ← los 5 contenidos almacenados
│   └── records.dart                ← récords de la sesión (ValueNotifier)
├── screens/
│   ├── catalogo_screen.dart        ← ListView.builder
│   ├── ficha_screen.dart
│   └── reproductor_screen.dart     ← abre el minijuego
├── juegos/
│   ├── piedra_papel_tijera.dart
│   ├── adivina_numero.dart
│   ├── tres_en_raya.dart
│   ├── reflejos.dart
│   └── memoria.dart
├── widgets/
│   ├── tarjeta_juego.dart
│   ├── estrellas_dificultad.dart
│   ├── marcador.dart
│   └── aviso_record.dart
└── theme/arcade_theme.dart         ← colores, tema y fondo degradado
test/
├── contenidos_test.dart            ← datos y récords
├── juegos_test.dart                ← reglas de cada juego
└── catalogo_test.dart              ← ListView.builder, navegación y partidas
```

## Ciclo de vida

- El catálogo y la ficha son `StatelessWidget`: escuchan los récords con `ValueListenableBuilder`.
- Cada minijuego es un `StatefulWidget`. Su estado (marcador, tablero, cartas) cambia con `setState()`.
- **Reflejos:** el reloj es un `Timer.periodic` que se cancela en `dispose()` si sales a mitad de partida.
- **Memoria:** el `Timer` que vuelve a tapar las cartas también se cancela en `dispose()`.
- **Adivina el número:** el `TextEditingController` se libera en `dispose()`.
