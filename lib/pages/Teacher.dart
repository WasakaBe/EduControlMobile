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
  int _currentIndex = 0; // Pestaña seleccionada

  // Lista de pantallas
  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      DashboardTeacherScreen(
        nombreUsuario: widget.nombreUsuario,
        fotoPerfilUrl: widget.fotoPerfilUrl,
      ),
      HorarioTeacherScreen(idUsuario: widget.idUsuario,),
       QrCodeTeacherScreen(userId: widget.idUsuario),
      NotificacionesTeacherScreen(userId: widget.idUsuario,),
    ]);
  }

  // Cambiar de pestaña con animación
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Aquí se usa MediaQuery en el método build, donde es seguro
    final double screenWidth = MediaQuery.of(context).size.width;
    final double position = _currentIndex * (screenWidth / 4);

    return Scaffold(
      body: _pages[_currentIndex], // Muestra la página seleccionada
      bottomNavigationBar: Stack(
        children: [
          // Barra de navegación
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromARGB(221, 12, 39, 28),
            selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
            unselectedItemColor: const Color.fromARGB(155, 189, 189, 189),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Horarios',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code),
                label: 'Código QR',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notificaciones',
              ),
            ],
          ),
          // Animación del deslizamiento bajo el ícono seleccionado
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: position,
            bottom: 0,
            child: Container(
              width: screenWidth / 4,
              height: 5,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
