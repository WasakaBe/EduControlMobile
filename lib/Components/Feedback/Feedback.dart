import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movil_educontrol/Api/api.dart';

class FeedbackModal {
  static Future<void> showFeedbackModal(BuildContext context, int idUsuario) async {
    // Verificar si se puede mostrar el feedback
    final canShowFeedback = await _canShowFeedback(idUsuario);
    if (!canShowFeedback) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El feedback solo puede enviarse cada 15 días.')),
      );
      return;
    }

    String selectedEmotion = ''; // Variable para almacenar la emoción seleccionada
    String selectedEmoji = ''; // Rastrea el emoji seleccionado (inicialmente ninguno)

    await showDialog(
      context: context,
      barrierDismissible: false, // Evitar que el modal se cierre al hacer clic fuera
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // Retorna false para deshabilitar el deslizamiento hacia atrás
            return false;
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              final screenWidth = MediaQuery.of(context).size.width;
              final emojiSize = screenWidth * 0.1; // Tamaño del emoji adaptado a la pantalla

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text('Agregar Feedback'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Tu opinión es importante para nosotros.\n ¿Te resultó útil la información que consultaste? Selecciona una opción para valorar la información mostrada:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 10.0, // Espacio horizontal entre los emojis
                      runSpacing: 10.0, // Espacio vertical entre los emojis si es necesario
                      alignment: WrapAlignment.center,
                      children: [
                        IconButton(
                          icon: Text(
                            "😃",
                            style: TextStyle(
                              fontSize: emojiSize,
                              color: selectedEmoji == 'satisfecho' ? Colors.yellow : Colors.green,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedEmotion = 'satisfecho';
                              selectedEmoji = 'satisfecho';
                            });
                          },
                        ),
                        IconButton(
                          icon: Text(
                            "🙂",
                            style: TextStyle(
                              fontSize: emojiSize,
                              color: selectedEmoji == 'medio satisfecho' ? Colors.yellow : Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedEmotion = 'medio satisfecho';
                              selectedEmoji = 'medio satisfecho';
                            });
                          },
                        ),
                        IconButton(
                          icon: Text(
                            "😐",
                            style: TextStyle(
                              fontSize: emojiSize,
                              color: selectedEmoji == 'bien' ? Colors.yellow : Colors.orange,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedEmotion = 'bien';
                              selectedEmoji = 'bien';
                            });
                          },
                        ),
                        IconButton(
                          icon: Text(
                            "🙁",
                            style: TextStyle(
                              fontSize: emojiSize,
                              color: selectedEmoji == 'mal' ? Colors.yellow : Colors.red,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedEmotion = 'mal';
                              selectedEmoji = 'mal';
                            });
                          },
                        ),
                        IconButton(
                          icon: Text(
                            "😡",
                            style: TextStyle(
                              fontSize: emojiSize,
                              color: selectedEmoji == 'peor' ? Colors.yellow : Colors.purple,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedEmotion = 'peor';
                              selectedEmoji = 'peor';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    child: const Text('Enviar Feedback'),
                    onPressed: () async {
                      if (selectedEmotion.isNotEmpty) {
                        bool feedbackEnviado = await _sendFeedback(idUsuario, selectedEmotion);
                        if (feedbackEnviado) {
                          Navigator.of(context).pop(); // Cierra el modal y habilita el deslizamiento
                          _showSuccessDialog(context);
                        } else {
                          _showErrorDialog(context, 'Hubo un error al enviar el feedback. Intenta nuevamente.');
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor selecciona una emoción')),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Verificar con el backend si se puede mostrar el modal de feedback
  static Future<bool> _canShowFeedback(int idUsuario) async {
    final url = Uri.parse('$baseUrl/can-show-feedback/$idUsuario');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['canShowFeedback'] == true;
      } else {
        print('Error al verificar el feedback: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
      return false;
    }
  }

  static Future<bool> _sendFeedback(int idUsuario, String emocion) async {
    final url = Uri.parse('$baseUrl/create/feedback');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idusuario': idUsuario,
          'emocion_feedback': emocion,
        }),
      );
      if (response.statusCode == 201) {
        print('Feedback enviado exitosamente');
        return true;
      } else {
        print('Error al enviar el feedback: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
      return false;
    }
  }

  // Mostrar el modal de éxito
  static void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
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
              '¡Éxito!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Tu feedback ha sido enviado exitosamente.',
              style: TextStyle(
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
                'CONTINUAR',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mostrar un diálogo de error
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
              '¡Oops!',
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
    );
  }
}
