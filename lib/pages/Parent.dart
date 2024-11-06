import 'package:flutter/material.dart';
import 'package:movil_educontrol/Screen/Parent/AlumnosScreen.dart';
import 'package:movil_educontrol/Screen/Parent/ParentDashboardScreen.dart';


class ParentScreen extends StatefulWidget {
  final String nombreUsuario;
  final int idUsuario;
final String fotoPerfilUrl; // Asegúrate de incluir esto

  const ParentScreen({
    super.key,
    required this.nombreUsuario,
    required this.idUsuario,
     required this.fotoPerfilUrl,
  });

  @override
  _ParentScreenState createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  int _currentIndex = 0;

  // Lista de pantallas
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ParentDashboardScreen(nombreUsuario: widget.nombreUsuario,fotoPerfilUrl: widget.fotoPerfilUrl, ),
      AlumnosScreen(idUsuario: widget.idUsuario),
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
    final double position = _currentIndex * (screenWidth / 2); // Cambiamos a 2

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
                icon: Icon(Icons.people),
                label: 'Alumnos',
              ),

            ],

          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: position,
            bottom: 0,
            child: Container(
              width: screenWidth / 2,
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
