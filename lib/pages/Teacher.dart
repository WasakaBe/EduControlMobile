import 'package:flutter/material.dart';
import 'package:movil_educontrol/Screen/Teacher/DashboardTeacherScreen.dart';
import 'package:movil_educontrol/Screen/Teacher/HorarioTeacherScreen.dart';
import 'package:movil_educontrol/Screen/Teacher/NotificacionesTeacherScreen.dart';
import 'package:movil_educontrol/Screen/Teacher/QrCodeTeacherScreen.dart';

class TeacherScreen extends StatefulWidget {
  final String nombreUsuario;
  final int idUsuario;
  final String fotoPerfilUrl;

  const TeacherScreen({
    super.key,
    required this.nombreUsuario,
    required this.idUsuario,
    required this.fotoPerfilUrl,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TeacherScreenState createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  int _currentIndex = 0; // Pestaña seleccionada actualmente

  // Lista de pantallas que se mostrarán en la navegación
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    // Se inicializa la lista de pantallas con los widgets correspondientes
    _pages.addAll([
      DashboardTeacherScreen(
        nombreUsuario: widget.nombreUsuario, // Nombre de usuario del profesor
        fotoPerfilUrl: widget.fotoPerfilUrl, // URL de la foto de perfil
      ),
      HorarioTeacherScreen(idUsuario: widget.idUsuario), // Pantalla para mostrar horarios
      QrCodeTeacherScreen(userId: widget.idUsuario), // Pantalla para mostrar código QR
      NotificacionesTeacherScreen(userId: widget.idUsuario), // Pantalla para mostrar notificaciones
    ]);
  }

  // Método para cambiar de pestaña con animación
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Actualiza el índice de la pestaña seleccionada
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se obtiene el ancho de la pantalla para calcular la posición del indicador de la pestaña
    final double screenWidth = MediaQuery.of(context).size.width;
    final double position = _currentIndex * (screenWidth / 4); // Posición del indicador basado en el índice

    return Scaffold(
      body: _pages[_currentIndex], // Muestra la página correspondiente al índice actual
      bottomNavigationBar: Stack(
        children: [
          // Barra de navegación inferior
          BottomNavigationBar(
            currentIndex: _currentIndex, // Índice actual para la barra de navegación
            onTap: _onItemTapped, // Llama a _onItemTapped al seleccionar un ítem
            type: BottomNavigationBarType.fixed, // Barra de navegación con ítems fijos
            backgroundColor: const Color.fromARGB(221, 12, 39, 28), // Color de fondo de la barra
            selectedItemColor: const Color.fromARGB(255, 255, 255, 255), // Color del ítem seleccionado
            unselectedItemColor: const Color.fromARGB(155, 189, 189, 189), // Color de ítems no seleccionados
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), // Ícono para la pantalla de Dashboard
                label: 'Dashboard', // Etiqueta para la pantalla de Dashboard
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule), // Ícono para la pantalla de Horarios
                label: 'Horarios', // Etiqueta para la pantalla de Horarios
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code), // Ícono para la pantalla de Código QR
                label: 'Código QR', // Etiqueta para la pantalla de Código QR
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications), // Ícono para la pantalla de Notificaciones
                label: 'Notificaciones', // Etiqueta para la pantalla de Notificaciones
              ),
            ],
          ),
          // Indicador animado que muestra la pestaña seleccionada
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300), // Duración de la animación del indicador
            curve: Curves.easeInOut, // Curva de animación suave
            left: position, // Posición horizontal del indicador
            bottom: 0, // Posición vertical del indicador
            child: Container(
              width: screenWidth / 4, // Ancho del indicador, adaptado a 4 pantallas
              height: 5, // Altura del indicador
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255), // Color del indicador
                borderRadius: BorderRadius.circular(10), // Bordes redondeados del indicador
              ),
            ),
          ),
        ],
      ),
    );
  }
}
