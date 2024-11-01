import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movil_educontrol/Api/api.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movil_educontrol/pages/Parent.dart';
import 'package:movil_educontrol/pages/Student.dart';
import 'package:movil_educontrol/pages/Teacher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _captchaController = TextEditingController();

  bool _isLoading = false;
  String _generatedCaptcha = '';

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

    // Genera un captcha aleatorio
void _generateCaptcha() {
  const chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  Random rnd = Random();
  setState(() {
    _generatedCaptcha = String.fromCharCodes(
      Iterable.generate(5, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
    _captchaController.clear(); // Limpiar campo al generar nuevo captcha
  });
}

   // Método para verificar el captcha
  bool _verifyCaptcha() {
    return _captchaController.text == _generatedCaptcha;
  }

  Future<void> _checkEmailAndLogin() async {
     if (!_verifyCaptcha()) {
      _showErrorDialog('Captcha incorrecto');
      _generateCaptcha(); // Regenerar el captcha si es incorrecto
      _captchaController.clear();
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Email y contraseña son requeridos');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final checkEmailResponse = await http.post(
        Uri.parse('$baseUrl/check-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo_usuario': email,
        }),
      );

      if (checkEmailResponse.statusCode == 404) {
        _showErrorDialog('Su correo es Inexistente');
          _generateCaptcha(); // Regenerar captcha si el correo es incorrecto
      } else if (checkEmailResponse.statusCode == 200) {
        _login(email, password);
      } else {
        _showErrorDialog('Error desconocido al verificar el correo');
      }
    } catch (error) {
      _showErrorDialog('Error en la solicitud de verificación: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo_usuario': email,
          'pwd_usuario': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final nombreUsuario = data['tbl_users']['nombre_usuario'];
        final int rolUsuario = data['tbl_users']['idRol'];
        final String fotoUsuario = data['tbl_users']['foto_usuario'];
          _generateCaptcha(); // Regenerar captcha si el correo es incorrecto
        _redirectUserByRole(rolUsuario, nombreUsuario,
            data['tbl_users']['id_usuario'], fotoUsuario);
        _showWelcomeDialog(nombreUsuario);
      } else if (response.statusCode == 401) {
        _showErrorDialog('Su contraseña es incorrecta');
          _generateCaptcha(); // Regenerar captcha si el correo es incorrecto
      } else {
        _showErrorDialog(data['error'] ?? 'Datos Incorrectos e inexistentes');
      }
    } catch (error) {
      _showErrorDialog('Error en la solicitud: $error');
    } finally {
      setState(() {
        _isLoading = false; // Ocultar loader
      });
    }
  }

  // Función para redirigir según el rol del usuario (sin el rol administrador)
  void _redirectUserByRole(int rolUsuario, String nombreUsuario, int idUsuario,
      String fotoPerfilUrl) {
    if (rolUsuario == 2) {
      // Estudiante
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              StudentScreen(
                nombreUsuario: nombreUsuario, 
                idUsuario: idUsuario,  
                fotoPerfilUrl: fotoPerfilUrl,),
        ),
      );
    } else if (rolUsuario == 3) {
      // Profesor
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeacherScreen(
            nombreUsuario: nombreUsuario,
            idUsuario: idUsuario,
            fotoPerfilUrl: fotoPerfilUrl,
          ),
        ),
      );
    } else if (rolUsuario == 4) {
      // Tutor o familiar
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ParentScreen(nombreUsuario: nombreUsuario, idUsuario: idUsuario,  fotoPerfilUrl: fotoPerfilUrl,),
        ),
      );
    } else {
      _showErrorDialog('Rol no reconocido.');
    }
  }

  // Mostrar un diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bordes redondeados
        ),
        backgroundColor: Colors.white, // Fondo blanco
        content: Column(
          mainAxisSize: MainAxisSize.min, // Ajuste del tamaño
          children: [
            // Icono del "fantasma" o similar para el error
            SvgPicture.asset(
              'assets/failed_ghost.svg', // Imagen de error
              height: 100,
            ),
            const SizedBox(height: 10),
            // Texto de error en rojo
            const Text(
              'Oops!',
              style: TextStyle(
                color: Colors.red, // Color rojo
                fontSize: 24, // Tamaño de fuente
                fontWeight: FontWeight.bold, // Negrita
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Texto de mensaje de error
            Text(
              message,
              style: const TextStyle(
                color: Colors.black54, // Color del texto secundario
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Espaciado
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                backgroundColor: Colors.red, // Fondo rojo
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Bordes redondeados del botón
                ),
              ),
              child: const Text(
                'Intentar de Nuevo',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Texto blanco
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mostrar un modal de bienvenida

  void _showWelcomeDialog(String nombreUsuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bordes redondeados
        ),
        backgroundColor: Colors.white, // Fondo blanco
        content: Column(
          mainAxisSize: MainAxisSize.min, // Ajuste del tamaño
          children: [
            // Icono del "fantasma" o similar
            SvgPicture.asset(
              'assets/success_ghost.svg', // Aquí puedes agregar la imagen que desees
              height: 100,
            ),
            const SizedBox(height: 10),
            // Texto de éxito en verde
            const Text(
              'Success!',
              style: TextStyle(
                color: Colors.green, // Color verde
                fontSize: 24, // Tamaño de fuente
                fontWeight: FontWeight.bold, // Negrita
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Texto de mensaje debajo del título
            Text(
              'Bienvenido, $nombreUsuario',
              style: const TextStyle(
                color: Colors.black54, // Color del texto secundario
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Espaciado
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                backgroundColor: Colors.green, // Color de fondo verde
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Bordes redondeados del botón
                ),
              ),
              child: const Text(
                'CONTINUE',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white, // Texto blanco
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_leaves.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Capa negra translúcida que cubre toda la pantalla
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // Contenido
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Ícono de salir alineado a la parte superior izquierda
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Spacer(),
                  // Campos de correo y contraseña
                  const Text(
                    'Iniciar de Sesión',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // Campo de Correo
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  // Campo de Contraseña
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 30),

  // Captcha con distorsión
                  CustomPaint(
                    painter: CaptchaPainter(_generatedCaptcha),
                    child: Container(
                      height: 50,
                               padding: const EdgeInsets.all(20.0),
                      alignment: Alignment.center,
                      child: const Text(
                        '',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
  // Campo de entrada de captcha
                  TextField(
                    controller: _captchaController,
                    decoration: InputDecoration(
                      labelText: 'Ingrese el texto de arriba',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  // Botón de Iniciar Sesión
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: _isLoading
                          ? null
                          : _checkEmailAndLogin, // Primero se verifica el correo
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 111, 175, 95))
                          : const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CaptchaPainter extends CustomPainter {
  final String captchaText;
  CaptchaPainter(this.captchaText);

  @override
  void paint(Canvas canvas, Size size) {

    // Para que el texto esté centrado en el canvas
    const textStyle = TextStyle(
      fontSize: 40,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.white,
      
    );

    // Coordenadas iniciales para empezar a pintar el texto
    double startX = 0;
    double startY = size.height / 2;

    for (int i = 0; i < captchaText.length; i++) {
      final character = captchaText[i];

      final textSpan = TextSpan(text: character, style: textStyle);

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: size.width);

      // Aquí aplicamos un ligero movimiento vertical para crear el efecto curveado
      double dy = sin(i * pi / 5) * 10;

      // Guardamos el estado actual del canvas
      canvas.save();

      // Movemos el canvas a la posición donde se pintará cada letra
      canvas.translate(startX, startY + dy);

      // Pintamos el carácter
      textPainter.paint(canvas, const Offset(0, 0));

      // Restauramos el estado del canvas
      canvas.restore();

      // Avanzamos la posición en X para la siguiente letra
      startX += textPainter.width + 5; // Agrega un poco de espaciado entre letras
    }
  }

  @override
  bool shouldRepaint(CaptchaPainter oldDelegate) {
    return oldDelegate.captchaText != captchaText;
  }
}