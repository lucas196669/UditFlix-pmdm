import 'package:flutter/material.dart';
import 'package:uditflix/models/contenido.dart';

import '../data/contenidos.dart';

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UDITflix'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contenidos.length,
        itemBuilder: (context, index) {
          final contenido = contenidos[index];

          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.play_circle_fill,
                color: Colors.deepPurple,
              ),

              title: Text(contenido.titulo),

              subtitle: Text(contenido.tipo),

              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}
