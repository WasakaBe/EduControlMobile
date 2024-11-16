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

  void _redirectUserByRole(int rolUsuario, String nombreUsuario, int idUsuario,
      String fotoPerfilUrl) {
    if (rolUsuario == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudentScreen(
            nombreUsuario: nombreUsuario,
            idUsuario: idUsuario,
            fotoPerfilUrl: fotoPerfilUrl,
          ),
        ),
      );
    } else if (rolUsuario == 3) {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParentScreen(
            nombreUsuario: nombreUsuario,
            idUsuario: idUsuario,
            fotoPerfilUrl: fotoPerfilUrl,
          ),
        ),
      );
    } else {
      _showErrorDialog('Rol no reconocido.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Bloquear el deslizamiento
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/failed_ghost.svg',
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'Oops!',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Intentar de Nuevo',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWelcomeDialog(String nombreUsuario) {
    showDialog(
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async => false, // Bloquear el deslizamiento
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/success_ghost.svg',
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'Success!',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Bienvenido, $nombreUsuario',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Bloquear siempre el deslizamiento
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background_leaves.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.6),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
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
      ),
    );
  }
}

class CaptchaPainter extends CustomPainter {
  final String captchaText;
  CaptchaPainter(this.captchaText);

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      fontSize: 40,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.white,
    );

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

      double dy = sin(i * pi / 5) * 10;

      canvas.save();

      canvas.translate(startX, startY + dy);

      textPainter.paint(canvas, const Offset(0, 0));

      canvas.restore();

      startX += textPainter.width + 5;
    }
  }

  @override
  bool shouldRepaint(CaptchaPainter oldDelegate) {
    return oldDelegate.captchaText != captchaText;
  }
}