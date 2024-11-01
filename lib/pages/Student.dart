import 'package:flutter/material.dart';
import 'package:movil_educontrol/Screen/Student/DashboardStudentScreen.dart';
import 'package:movil_educontrol/Screen/Student/HorarioStudentScreen.dart';
import 'package:movil_educontrol/Screen/Student/NotificacionesStudentScreen.dart';
import 'package:movil_educontrol/Screen/Student/QrCodeStudentScreen.dart';

class StudentScreen extends StatefulWidget {
  final String nombreUsuario;
  final int idUsuario;
  final String fotoPerfilUrl; // Asegúrate de incluir esto

  const StudentScreen({
    super.key,
    required this.nombreUsuario,
    required this.idUsuario,
    required this.fotoPerfilUrl, // Asegúrate de que se pase este parámetro
  });

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  int _currentIndex = 0;

  // Lista de pantallas
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardStudentScreen(
        nombreUsuario: widget.nombreUsuario,
        fotoPerfilUrl: widget.fotoPerfilUrl, // Corregimos este punto
      ),
      HorarioStudentScreen(idUsuario: widget.idUsuario),
      QrCodeStudentScreen(studentId: widget.idUsuario),
      NotificacionesStudentScreen(userId: widget.idUsuario),
    ];
  }

  // Cambiar de pestaña con animación
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double position = _currentIndex * (screenWidth / 4);

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Stack(
        children: [
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
