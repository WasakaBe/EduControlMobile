import 'dart:convert'; // Para decodificar Base64
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ParentDashboardScreen extends StatelessWidget {
  final String nombreUsuario;
  final String fotoPerfilUrl; // Imagen en Base64

  const ParentDashboardScreen({
    super.key,
    required this.nombreUsuario,
    required this.fotoPerfilUrl, // Asegúrate de que se pase este parámetro
  });

  @override
  Widget build(BuildContext context) {
    // Decodificar la imagen en Base64
    Uint8List? imageBytes;
    if (fotoPerfilUrl.isNotEmpty) {
      imageBytes = base64Decode(fotoPerfilUrl);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Mostrar la imagen de perfil si está disponible
          imageBytes != null
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(imageBytes),
                )
              : const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50),
                ),
          const SizedBox(height: 20),
          Text(
            'Bienvenido(a), Tutor/Familiar $nombreUsuario',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implementar lógica de cerrar sesión
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Texto blanco
              ),
            ),
          ),
        ],
      ),
    );
  }
}
