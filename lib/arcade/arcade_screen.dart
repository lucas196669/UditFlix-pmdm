import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'overlays/game_over_overlay.dart';
import 'overlays/inicio_overlay.dart';
import 'udit_arcade_game.dart';

/// Pantalla que contiene el juego UDIT Arcade (GameWidget de Flame).
class ArcadeScreen extends StatefulWidget {
  const ArcadeScreen({super.key});

  @override
  State<ArcadeScreen> createState() => _ArcadeScreenState();
}

class _ArcadeScreenState extends State<ArcadeScreen> {
  // Se crea una sola vez para que no se reinicie el juego al reconstruir.
  final UditArcadeGame _game = UditArcadeGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Volver a UDITflix',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.sports_esports_rounded, color: AppTheme.moradoClaro),
            SizedBox(width: 10),
            Text('UDIT Arcade'),
          ],
        ),
      ),
      body: GameWidget<UditArcadeGame>(
        game: _game,
        initialActiveOverlays: const [UditArcadeGame.overlayInicio],
        // Overlays: widgets de Flutter que se muestran encima del juego.
        overlayBuilderMap: {
          UditArcadeGame.overlayInicio: (context, game) => const InicioOverlay(),
          UditArcadeGame.overlayGameOver: (context, game) => GameOverOverlay(
                game: game,
                onVolver: () => Navigator.pop(context),
              ),
        },
      ),
    );
  }
}
