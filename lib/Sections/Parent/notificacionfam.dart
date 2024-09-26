import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';

class NotificacionFamScreen extends StatefulWidget {
  final int idAlumno;

  const NotificacionFamScreen({Key? key, required this.idAlumno})
      : super(key: key);

  @override
  _NotificacionFamScreenState createState() => _NotificacionFamScreenState();
}

class _NotificacionFamScreenState extends State<NotificacionFamScreen> {
  bool isLoading = false;
  List<dynamic> notificaciones = [];

  @override
  void initState() {
    super.initState();
    _fetchNotificaciones();
  }

  // Función para obtener las notificaciones del alumno
  Future<void> _fetchNotificaciones() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/notificaciones/${widget.idAlumno}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Filtrar solo las notificaciones de "Asistencia"
        setState(() {
          notificaciones = data
              .where((notificacion) => notificacion['subject_notificacion']
                  .toString()
                  .toLowerCase()
                  .contains('asistencia'))
              .toList();
        });
      } else {
        _showAlert('No se encontraron notificaciones.');
      }
    } catch (e) {
      _showAlert('Error al conectarse con el servidor.');
    }

    setState(() {
      isLoading = false;
    });
  }

  // Función para mostrar alertas
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027), // Colores de fondo degradado
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notificaciones.isEmpty
                ? const Center(
                    child:
                        Text('No se encontraron notificaciones de asistencia.'))
                : ListView.builder(
                    itemCount: notificaciones.length,
                    itemBuilder: (context, index) {
                      final notificacion = notificaciones[index];
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16), // Bordes redondeados
                          ),
                          color: const Color(
                              0xFF1C1C1C), // Fondo oscuro para las tarjetas
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.notifications,
                                        color: Colors.blueAccent, size: 30),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        notificacion['subject_notificacion'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Mensaje: ${notificacion['message_notificacion']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors
                                        .white70, // Color gris suave para el texto
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        color: Colors.white70, size: 20),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Fecha: ${notificacion['fecha_notificaciones']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
