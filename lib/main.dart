import 'dart:async'; // Para manejar el temporizador
import 'dart:convert'; // Para decodificar imágenes en base64
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Librería para hacer peticiones HTTP
import 'pages/Admin.dart'; // Importar la pantalla de Administrador
import 'pages/Student.dart'; // Importar la pantalla de Estudiante
import 'pages/Teacher.dart'; // Importar la pantalla de Docente
import 'pages/Parent.dart'; // Importar la pantalla de Familiar
import 'package:edu_control_movile/Api/api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EDU CONTROL',
      theme: ThemeData(
        brightness: Brightness.dark, // Tema oscuro
        primarySwatch: Colors.green, // Colores principales en verde
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PageController _pageController =
      PageController(); // Controlador de páginas
  List<String> images = []; // Lista de imágenes en base64
  int currentPage = 0;
  Timer? _carouselTimer; // Temporizador para deslizamiento automático

  @override
  void initState() {
    super.initState();
    _fetchBackgroundImages();
    _startAutoSlide(); // Iniciar el deslizamiento automático
  }

  // Deslizamiento automático cada 3 segundos
  void _startAutoSlide() {
    Future.delayed(const Duration(milliseconds: 800), () {
      _carouselTimer =
          Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (currentPage < images.length - 1) {
          currentPage++;
        } else {
          currentPage = 0;
        }

        if (_pageController.hasClients) {
          _pageController.animateToPage(
            currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut, // Animación para el cambio de página
          );
        }
      });
    });
  }

  // Detener el temporizador cuando se destruye la pantalla
  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _fetchBackgroundImages() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/actividades_noticias'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          setState(() {
            // Guardamos todas las imágenes de las noticias
            images = data
                .map<String>(
                    (actividad) => actividad['imagen_actividad_noticia'])
                .toList();
          });
        }
      } else {
        // ignore: avoid_print
        print(
            'Error al obtener las actividades/noticias: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al hacer la petición: $e');
    }
  }

  // Verificar si el correo existe en el sistema
  Future<bool> _checkEmailExists(String email) async {
    final url = Uri.parse('$baseUrl/check-email');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo_usuario': email}),
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      // Verifica si el valor 'exists' es null y asígnale un valor por defecto
      bool exists = decodedResponse['exists'] ?? false;
      return exists;
    } else {
      return false;
    }
  }

  // Iniciar sesión
  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showAlert('Por favor, ingrese ambos datos.');
      return;
    }

    final bool emailExists = await _checkEmailExists(email);

    if (!emailExists) {
      _showAlert('El correo electrónico no existe.');
      return;
    }

    // Llamada a la API de login
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo_usuario': email, 'pwd_usuario': password}),
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body)['tbl_users'];
      final String nombreUsuario = userData['nombre_usuario'] ?? 'Usuario';
      final int rolUsuario =
          userData['idRol'] ?? 0; // Valor por defecto en caso de que sea null

      // Redirigir según el rol del usuario
      if (rolUsuario == 1) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => AdminScreen(
                nombreUsuario: nombreUsuario,
                idUsuario: userData['id_usuario']),
          ),
        );
      } else if (rolUsuario == 2) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => StudentScreen(
              nombreUsuario: nombreUsuario,
              idUsuario:
                  userData['id_usuario'], // Pasamos también el ID del usuario
            ),
          ),
        );
      } else if (rolUsuario == 3) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => TeacherScreen(
              nombreUsuario: nombreUsuario,
              idUsuario: userData['id_usuario'],
            ),
          ),
        );
      } else if (rolUsuario == 4) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => ParentScreen(
              nombreUsuario: nombreUsuario,
              idUsuario: userData['id_usuario'],
            ),
          ),
        );
      } else {
        _showAlert('Rol no reconocido.');
      }
    } else {
      _showAlert('Email o contraseña incorrectos.');
    }
  }

  // Mostrar alerta
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.black87, // Color de fondo
          title: const Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.greenAccent, // Color del ícono
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                'Información',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white70, // Color del mensaje
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent, // Color del botón
                  foregroundColor: Colors.black, // Color del texto en el botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (images.isNotEmpty)
            PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Imagen de fondo decodificada desde base64
                    Image.memory(
                      base64Decode(images[index]),
                      fit: BoxFit.cover,
                    ),
                    // Agregamos una capa oscura encima de la imagen
                    Container(
                      color:
                          const Color.fromARGB(241, 0, 0, 0).withOpacity(0.5),
                    ),
                  ],
                );
              },
            )
          else
            const Center(
                child:
                    CircularProgressIndicator()), // Cargando mientras llega la imagen
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Bienvenido a EduControl',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Por favor ingrese sus datos de manera correcta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                    hintText: 'Correo Electrónico',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black54,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    hintText: 'Contraseña',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.black54,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(color: Colors.green, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _login,
                      child: const Text(
                        'LOGIN NOW',
                        style: TextStyle(color: Colors.green, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
