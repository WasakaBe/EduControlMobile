import 'package:flutter/material.dart';
import 'package:movil_educontrol/Form/Register.dart';
import 'package:movil_educontrol/Form/login.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://cce2df658b1444eb3b430b42c42e31e4@o4508286180196352.ingest.us.sentry.io/4508286183079936';

      // Configurar el muestreo de trazas (Tracing)
      options.tracesSampleRate = 1.0; // Captura el 100% de las transacciones.

      // Configurar la versión del release
      options.release =
          'eb4d6b0405eedf5c25f58e6d4b0933185fb2d3bb@0.1.0'; // Versión del release.
    },
    appRunner: () => runApp(const MyApp()),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDU CONTROL',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: const Color.fromARGB(158, 19, 56, 54).withOpacity(0.6),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Spacer(flex: 2),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Text(
                        'EDU CONTROL',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Experimentando una vida bella de estudiante',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Espaciador para empujar los botones hacia abajo
                const Spacer(flex: 3),

                // Botones centrados en la parte inferior
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // Botón transparente
                            side: const BorderSide(color: Colors.white), // Borde blanco
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            // Navegar a la pantalla de registro
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // Botón blanco
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            // Navegar a la pantalla de login
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Espacio adicional y el enlace de "Términos de Servicio" en la parte inferior
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        // Acción para los Términos de Servicio
                      },
                      child: const Text(
                        'Términos de Servicio',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
