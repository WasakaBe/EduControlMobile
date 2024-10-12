import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movil_educontrol/Api/api.dart';

class NotificacionesStudentScreen extends StatefulWidget {
  final int userId;

  const NotificacionesStudentScreen({super.key, required this.userId});

  @override
  _NotificacionesStudentScreenState createState() =>
      _NotificacionesStudentScreenState();
}

class _NotificacionesStudentScreenState
    extends State<NotificacionesStudentScreen> {
  bool isLoading = true;
  List<dynamic> notificaciones = [];
  int? alumnoId; // Almacenará el ID del alumno
  String? errorMessage;

  // Variables para la paginación
  int currentPage = 0;
  int itemsPerPage = 5; // Número de notificaciones por página

  @override
  void initState() {
    super.initState();
    _fetchAlumnoId(); // Primero obtenemos el ID del alumno
  }

  Future<void> _fetchAlumnoId() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/alumno/usuario/${widget.userId}'));

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
    int totalPages = (notificaciones.length / itemsPerPage).ceil(); // Total de páginas

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : notificaciones.isEmpty
                  ? const Center(
                      child: Text(
                        'No se encontraron notificaciones',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Center( // Para centrar vertical y horizontalmente las notificaciones
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: (notificaciones.length < itemsPerPage)
                                  ? notificaciones.length
                                  : ((currentPage + 1) * itemsPerPage >
                                          notificaciones.length
                                      ? notificaciones.length % itemsPerPage
                                      : itemsPerPage),
                              itemBuilder: (context, index) {
                                int actualIndex =
                                    index + currentPage * itemsPerPage;
                                final notificacion = notificaciones[actualIndex];
                                return Center(
                                  child: SizedBox( // Para ajustar el ancho del contenedor
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notificacion[
                                                  'subject_notificacion'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.message,
                                                    color: Colors.teal[700],
                                                    size: 20),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Mensaje: ${notificacion['message_notificacion']}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_today,
                                                    color: Colors.teal[700],
                                                    size: 20),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Fecha: ${notificacion['fecha_notificaciones']}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Controles de paginación centrados
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: currentPage > 0
                                  ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                  : null,
                            ),
                            Text('Página ${currentPage + 1} de $totalPages'),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward),
                              onPressed: currentPage < totalPages - 1
                                  ? () {
                                      setState(() {
                                        currentPage++;
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
    );
  }
}
