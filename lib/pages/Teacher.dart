import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';
import 'package:edu_control_movile/Sections/Teacher/credencial_docente_screen.dart';
import 'package:edu_control_movile/Sections/Teacher/horario_escolar_docente_screen.dart';

class TeacherScreen extends StatefulWidget {
  final String nombreUsuario;
  final int idUsuario;

  const TeacherScreen(
      {Key? key, required this.nombreUsuario, required this.idUsuario})
      : super(key: key);

  @override
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  String? fotoBase64;
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchUsuario();
  }

  // Función para obtener los datos del usuario
  Future<void> _fetchUsuario() async {
    final response =
        await http.get(Uri.parse('$baseUrl/usuario/${widget.idUsuario}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        fotoBase64 = data['foto_usuario'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener los datos del usuario: ${response.statusCode}');
    }
  }

  // Función para cambiar de pantalla en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Función para devolver la pantalla correspondiente
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        // Pantalla principal (Dashboard)
        return _dashboardView();
      case 1:
        return CredencialDocenteScreen(idUsuario: widget.idUsuario);
      case 2:
        return HorarioEscolarDocenteScreen(idUsuario: widget.idUsuario);
      default:
        return _dashboardView();
    }
  }

  // Función que define la vista principal del Dashboard (pantalla original)
  Widget _dashboardView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          const CircularProgressIndicator()
        else
          CircleAvatar(
            radius: 100,
            backgroundColor: Colors.white,
            backgroundImage: fotoBase64 != null
                ? MemoryImage(base64Decode(fotoBase64!))
                : const AssetImage('image/logo_cbta_5.png') as ImageProvider,
          ),
        const SizedBox(height: 30),
        Text(
          'Bienvenido, ${widget.nombreUsuario}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        // Agregamos el botón de cerrar sesión
        SizedBox(
          width: 200, // Ajusta el ancho del botón
          height: 50, // Ajusta la altura del botón
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red, // Color rojo para el botón de cerrar sesión
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              // Lógica para cerrar sesión
              Navigator.pop(
                  context); // Regresa a la pantalla anterior o principal
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(78, 56, 56, 56),
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
        ),
        child: _getScreen(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge),
            label: 'Credencial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Horario',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
