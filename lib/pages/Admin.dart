import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Sections/Admin/tablesadmin.dart'; // Importar la pantalla de Tablas
import 'package:edu_control_movile/Sections/Admin/websiteadmin.dart'; // Importar la pantalla de Website
import 'package:edu_control_movile/Sections/Admin/mensajesadmin.dart'; // Importar la pantalla de Mensajes
import 'package:edu_control_movile/Sections/Admin/credencialadmin.dart'; // Importar la pantalla de Credencial
import 'package:edu_control_movile/Sections/Admin/horariosadmin.dart'; // Importar la pantalla de Horarios
import 'package:edu_control_movile/Sections/Admin/informacionadmin.dart'; // Importar la pantalla de Información
import 'package:edu_control_movile/Api/api.dart'; // Para el uso de la API

class AdminScreen extends StatefulWidget {
  final String nombreUsuario;
  final int idUsuario;

  const AdminScreen({super.key, required this.nombreUsuario, required this.idUsuario});

  @override
  // ignore: library_private_types_in_public_api
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
    final response = await http.get(Uri.parse('$baseUrl/usuario/${widget.idUsuario}'));

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
        return _dashboardView();
      case 1:
        return const TablesAdminScreen(); // Pantalla de Tablas
      case 2:
        return  const WebsiteAdminScreen(); // Pantalla de Website
      case 3:
        return InformacionAdminScreen(); // Pantalla de Información
      case 4:
        return CredencialAdminScreen(); // Pantalla de Credencial
      case 5:
        return HorariosAdminScreen(); // Pantalla de Horarios
      case 6:
        return MensajesAdminScreen(); // Pantalla de Mensajes
      default:
        return _dashboardView(); // Pantalla por defecto
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
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
        const SizedBox(height: 30),
        Text(
          'Bienvenido Administrador, ${widget.nombreUsuario}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 30),
        // Botón de cerrar sesión
        SizedBox(
          width: 200,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Regresa a la pantalla anterior o principal
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
            icon: Icon(Icons.table_chart),
            label: 'Tablas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'Website',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Información',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.badge),
            label: 'Credencial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Horarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
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
