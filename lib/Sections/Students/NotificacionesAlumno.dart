import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';

class NotificacionesAlumnoScreen extends StatefulWidget {
  final int idUsuario;

  const NotificacionesAlumnoScreen({super.key, required this.idUsuario});

  @override
  _NotificacionesAlumnoScreenState createState() =>
      _NotificacionesAlumnoScreenState();
}

class _NotificacionesAlumnoScreenState
    extends State<NotificacionesAlumnoScreen> {
  bool isLoading = true;
  List<dynamic> notificaciones = [];
  int? alumnoId; // Almacenará el ID del alumno
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAlumnoId(); // Primero obtenemos el ID del alumno
  }

  // Función para obtener el ID del alumno desde el ID del usuario
  Future<void> _fetchAlumnoId() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/alumno/usuario/${widget.idUsuario}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          alumnoId = data['id_alumnos']; // Guardamos el ID del alumno
          _fetchNotificaciones(); // Luego obtenemos las notificaciones
        });
      } else {
        setState(() {
          errorMessage = 'Error al obtener el ID del alumno';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error al obtener el ID del alumno: ${error.toString()}';
        isLoading = false;
      });
    }
  }

  // Función para obtener las notificaciones del alumno desde la API
  Future<void> _fetchNotificaciones() async {
    if (alumnoId == null) return;

    try {
      final response =
          await http.get(Uri.parse('$baseUrl/notificaciones/$alumnoId'));

      if (response.statusCode == 200) {
        setState(() {
          notificaciones = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error al obtener las notificaciones';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage =
            'Error al obtener las notificaciones: ${error.toString()}';
        isLoading = false;
      });
    }
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
            : errorMessage != null
                ? Center(child: Text(errorMessage!))
                : notificaciones.isEmpty
                    ? const Center(
                        child: Text('No se encontraron notificaciones.'))
                    : ListView.builder(
                        itemCount: notificaciones.length,
                        itemBuilder: (context, index) {
                          final notificacion = notificaciones[index];
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16), // Bordes redondeados
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
                                            notificacion[
                                                'subject_notificacion'],
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
