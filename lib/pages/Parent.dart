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
  int _currentIndex = 0; // Índice actual que indica la pantalla seleccionada en el BottomNavigationBar

  // Lista de pantallas disponibles en la navegación inferior
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    
    // Inicializamos la lista de pantallas, configurando cada una con los parámetros necesarios
    _pages = [
      ParentDashboardScreen(
        nombreUsuario: widget.nombreUsuario,
        fotoPerfilUrl: widget.fotoPerfilUrl, // Información del usuario para el dashboard
      ),
      AlumnosScreen(idUsuario: widget.idUsuario), // Pantalla de alumnos
    ];
  }

  // Método para cambiar de pestaña en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index; // Actualiza el índice actual a la pestaña seleccionada
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ancho de la pantalla para calcular la posición del indicador de pestaña
    final double screenWidth = MediaQuery.of(context).size.width;
    final double position = _currentIndex * (screenWidth / 2); // Dividimos por 2 porque hay 2 pantallas

    return Scaffold(
      // Cuerpo de la pantalla muestra el widget correspondiente al índice actual
      body: _pages[_currentIndex],
      
      // Barra de navegación inferior
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            currentIndex: _currentIndex, // Índice actual para la barra de navegación
            onTap: _onItemTapped, // Cambia la pestaña cuando se toca un ítem
            type: BottomNavigationBarType.fixed, // Barra de navegación fija
            backgroundColor: const Color.fromARGB(221, 12, 39, 28), // Color de fondo de la barra
            selectedItemColor: const Color.fromARGB(255, 255, 255, 255), // Color de ítem seleccionado
            unselectedItemColor: const Color.fromARGB(155, 189, 189, 189), // Color de ítem no seleccionado
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard', // Etiqueta para la pantalla de Dashboard
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Alumnos', // Etiqueta para la pantalla de Alumnos
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
              width: screenWidth / 2, // Ancho del indicador, adaptado a 2 pantallas
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
