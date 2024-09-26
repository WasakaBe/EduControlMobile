import 'package:edu_control_movile/Sections/Admin/Tables/GradosTableAdmin.dart';
import 'package:edu_control_movile/Sections/Admin/Tables/GruposTableAdmin.dart';
import 'package:flutter/material.dart';
import 'package:edu_control_movile/Sections/Admin/Tables/UsersTableAdmin.dart';
import 'package:edu_control_movile/Sections/Admin/Tables/AsignaturasTableAdmin.dart';
import 'package:edu_control_movile/Sections/Admin/Tables/TrasladosTableAdmin.dart';
import 'package:edu_control_movile/Sections/Admin/Tables/TransportesTableAdmin.dart';
import 'package:edu_control_movile/Sections/Admin/Tables/PreguntasTableAdmin.dart';
import 'package:edu_control_movile/Sections/Admin/Tables/RelacionFamiliarTableAdmin.dart';

class TablesAdminScreen extends StatelessWidget {
  const TablesAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Tablas de Administración'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration:const BoxDecoration(
                color: Colors.green,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 const Text(
                    'Menú de Tablas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                    icon:const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Cerrar el Drawer
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading:const Icon(Icons.people),
              title:const Text('Usuarios'),
              onTap: () {
                // Cerrar el Drawer y navegar
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => UsersTableAdminScreen()));
              },
            ),
            ListTile(
              leading:const Icon(Icons.book),
              title:const Text('Asignaturas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AsignaturasTableAdminScreen()));
              },
            ),
            ListTile(
              leading:const Icon(Icons.transfer_within_a_station),
              title:const Text('Traslados'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TrasladosTableAdminScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_bus),
              title:const Text('Transportes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => TransportesTableAdminScreen()));
              },
            ),
            ListTile(
              leading:const Icon(Icons.grade),
              title:const Text('Grados'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => GradosTableAdminScreen()));
              },
            ),
            ListTile(
              leading:const Icon(Icons.group),
              title:const Text('Grupos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => GruposTableAdminScreen()));
              },
            ),
            ListTile(
              leading:const Icon(Icons.question_answer),
              title:const Text('Preguntas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PreguntasTableAdminScreen()));
              },
            ),
            ListTile(
              leading:const Icon(Icons.family_restroom),
              title:const Text('Relación Familiar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => RelacionFamiliarTableAdminScreen()));
              },
            ),
          ],
        ),
      ),
      body:const  Center(
        child: Text(
          'Tablas de Administración',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
