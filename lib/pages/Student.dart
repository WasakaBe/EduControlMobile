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
  int _currentIndex = 0; // Índice actual para controlar la pantalla seleccionada en el BottomNavigationBar

  // Lista de pantallas que el usuario puede navegar
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    
    // Inicializamos la lista de pantallas a las que el usuario puede acceder
    _pages = [
      DashboardStudentScreen(
        nombreUsuario: widget.nombreUsuario,
        fotoPerfilUrl: widget.fotoPerfilUrl, // Pasamos el nombre y foto del usuario al dashboard
      ),
      HorarioStudentScreen(idUsuario: widget.idUsuario), // Pantalla para ver el horario
      QrCodeStudentScreen(studentId: widget.idUsuario),  // Pantalla de código QR del estudiante
      NotificacionesStudentScreen(userId: widget.idUsuario), // Pantalla de notificaciones
    ];
  }

  // Método para cambiar de pestaña en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Actualiza el índice actual con el nuevo índice seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ancho de la pantalla, utilizado para calcular la posición de la animación
    final double screenWidth = MediaQuery.of(context).size.width;
    // Calcula la posición para el indicador de la pestaña seleccionada
    final double position = _currentIndex * (screenWidth / 4);

    return Scaffold(
      // Muestra la pantalla actual según el índice seleccionado
      body: _pages[_currentIndex],
      
      // Barra de navegación inferior personalizada
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            currentIndex: _currentIndex, // Define el índice actual en la barra de navegación
            onTap: _onItemTapped, // Al pulsar, cambia la pestaña usando el método _onItemTapped
            type: BottomNavigationBarType.fixed, // Tipo de barra de navegación fija
            backgroundColor: const Color.fromARGB(221, 12, 39, 28), // Color de fondo de la barra
            selectedItemColor: const Color.fromARGB(255, 255, 255, 255), // Color de elemento seleccionado
            unselectedItemColor: const Color.fromARGB(155, 189, 189, 189), // Color de elemento no seleccionado
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard', // Etiqueta para la pantalla de Dashboard
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Horarios', // Etiqueta para la pantalla de Horarios
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.qr_code),
                label: 'Código QR', // Etiqueta para la pantalla de Código QR
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notificaciones', // Etiqueta para la pantalla de Notificaciones
              ),
            ],
          ),
          // Indicador animado que muestra la pestaña seleccionada
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300), // Duración de la animación
            curve: Curves.easeInOut, // Curva de animación suave
            left: position, // Posición horizontal del indicador
            bottom: 0, // Posición vertical del indicador
            child: Container(
              width: screenWidth / 4, // Ancho del indicador (un cuarto de la pantalla)
              height: 5, // Altura del indicador
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255), // Color del indicador
                borderRadius: BorderRadius.circular(10), // Borde redondeado del indicador
              ),
            ),
          ),
        ],
      ),
    );
  }
}
