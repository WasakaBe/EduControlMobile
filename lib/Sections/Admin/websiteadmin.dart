import 'package:edu_control_movile/Sections/Admin/Website/CarruselAdmin.dart';
import 'package:flutter/material.dart';

class WebsiteAdminScreen extends StatelessWidget {
  const WebsiteAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Website'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menú de Website',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Cerrar el Drawer
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Carrusel'),
              onTap: () {
                // Navegación o acción para "Carrusel"
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CarruselAdmin()));
              },
            ),
            ListTile(
              title: const Text('Bienvenida'),
              onTap: () {
                // Navegación o acción para "Bienvenida"
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Misión - Visión'),
              onTap: () {
                // Navegación o acción para "Misión - Visión"
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Noticias'),
              onTap: () {
                // Navegación o acción para "Noticias"
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Inscripción'),
              onTap: () {
                // Navegación o acción para "Inscripción"
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Cultural'),
              onTap: () {
                // Navegación o acción para "Cultural"
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Carreras Técnicas'),
              onTap: () {
                // Navegación o acción para "Carreras Técnicas"
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Acerca De'),
              onTap: () {
                // Navegación o acción para "Acerca De"
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Administrar Website',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
