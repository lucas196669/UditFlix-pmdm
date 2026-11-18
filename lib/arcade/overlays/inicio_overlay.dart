import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Pantalla de inicio "Toca para empezar".
/// IgnorePointer deja pasar el toque al juego, que es quien empieza la partida.
class InicioOverlay extends StatelessWidget {
  const InicioOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return IgnorePointer(
      child: Align(
        alignment: const Alignment(0, 0.35),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: BoxDecoration(
            color: AppTheme.superficie.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.morado, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.touch_app_rounded, size: 36, color: AppTheme.moradoClaro),
              const SizedBox(height: 8),
              Text('Toca para empezar', style: textos.headlineSmall),
              const SizedBox(height: 4),
              Text(
                'Cada toque hace saltar a la palomita.\nEsquiva las tiras de película.',
                textAlign: TextAlign.center,
                style: textos.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
