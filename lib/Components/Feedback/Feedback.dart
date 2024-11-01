import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:movil_educontrol/Api/api.dart';
import 'dart:convert';

class FeedbackModal {
  static Future<void> showFeedbackModal(BuildContext context, int idUsuario) async {
    String selectedEmotion = ''; // Variable para guardar la emoción seleccionada
    TextEditingController motivoController = TextEditingController();

    // Variable para rastrear la emoción seleccionada (inicialmente ninguna)
    String selectedEmoji = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Obtener el tamaño de la pantalla
            final screenWidth = MediaQuery.of(context).size.width;
            final emojiSize = screenWidth * 0.1;  // Tamaño de emoji adaptado a la pantalla
            final textFieldWidth = screenWidth * 0.8; // Ancho del campo de texto adaptado a la pantalla

            return AlertDialog(
              title: const Text('Déjanos tu Feedback'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Emojis para la emoción usando Wrap para evitar overflow
                  Wrap(
                    spacing: 10.0, // Espaciado horizontal entre emojis
                    runSpacing: 10.0, // Espaciado vertical entre emojis si es necesario
                    alignment: WrapAlignment.center,
                    children: [
                      IconButton(
                        icon: Text(
                          "😃",
                          style: TextStyle(
                            fontSize: emojiSize,
                            color: selectedEmoji == 'satisfecho' ? Colors.yellow : Colors.black,
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
                            color: selectedEmoji == 'medio satisfecho' ? Colors.yellow : Colors.black,
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
                            color: selectedEmoji == 'bien' ? Colors.yellow : Colors.black,
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
                            color: selectedEmoji == 'mal' ? Colors.yellow : Colors.black,
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
                            color: selectedEmoji == 'peor' ? Colors.yellow : Colors.black,
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
                  const SizedBox(height: 10),
                  // Campo de texto para el motivo
                  SizedBox(
                    width: textFieldWidth,
                    child: TextField(
                      controller: motivoController,
                      decoration: const InputDecoration(
                        labelText: '¿Por qué seleccionaste esa emoción?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Enviar Feedback'),
                  onPressed: () async {
                    // Enviar el feedback al backend
                    if (selectedEmotion.isNotEmpty && motivoController.text.isNotEmpty) {
                      // Cerrar el modal de feedback antes de mostrar el modal de éxito o error
                      Navigator.of(context).pop(); 

                      bool feedbackEnviado = await _sendFeedback(idUsuario, selectedEmotion, motivoController.text);
                      if (feedbackEnviado) {
                        _showSuccessDialog(context);
                      } else {
                        _showErrorDialog(context, 'Hubo un error al enviar el feedback. Intenta nuevamente.');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor selecciona una emoción y escribe un motivo')),
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Future<bool> _sendFeedback(int idUsuario, String emocion, String motivo) async {
    final url = Uri.parse('$baseUrl/create/feedback'); // Cambia esta URL por la tuya
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idusuario': idUsuario,
          'emocion_feedback': emocion,
          'motivo_feedback': motivo,
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
              'Success!',
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
                Navigator.of(context).pop(); // Cierra el diálogo
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
    );
  }

  // Mostrar un diálogo de error
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
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
                Navigator.of(context).pop(); // Cierra el diálogo
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
