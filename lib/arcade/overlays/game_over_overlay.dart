import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../udit_arcade_game.dart';

/// Overlay de Flutter que aparece al chocar: puntuación, récord y botones.
class GameOverOverlay extends StatelessWidget {
  final UditArcadeGame game;
  final VoidCallback onVolver;

  const GameOverOverlay({super.key, required this.game, required this.onVolver});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return ColoredBox(
      color: AppTheme.fondo.withValues(alpha: 0.6),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppTheme.morado, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Game Over', style: textos.headlineLarge),
                const SizedBox(height: 16),
                Text('Puntuación', style: textos.bodyMedium),
                Text(
                  '${game.puntuacion}',
                  style: textos.headlineLarge?.copyWith(fontSize: 48, color: AppTheme.moradoClaro),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events_rounded, color: AppTheme.valoracion, size: 20),
                    const SizedBox(width: 6),
                    Text('Mejor récord de la sesión: ${game.mejorRecord}', style: textos.titleMedium),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Reiniciar'),
                  onPressed: game.reiniciar,
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  icon: const Icon(Icons.movie_rounded),
                  label: const Text('Volver a UDITflix'),
                  onPressed: onVolver,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
