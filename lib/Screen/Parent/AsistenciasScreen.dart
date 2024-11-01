import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movil_educontrol/Api/api.dart';

class AsistenciasScreen extends StatefulWidget {
  final int idAlumno;

  const AsistenciasScreen({super.key, required this.idAlumno});

  @override
  // ignore: library_private_types_in_public_api
  _AsistenciasScreenState createState() => _AsistenciasScreenState();
}

class _AsistenciasScreenState extends State<AsistenciasScreen> {
  bool isLoading = false;
  List<dynamic> notificaciones = [];

  // Variables para la paginación
  int currentPage = 0;
  final int itemsPerPage = 4; // Número de notificaciones por página

  @override
  void initState() {
    super.initState();
    _fetchNotificaciones();
  }

  // Función para obtener las notificaciones de asistencia del alumno
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
    int totalPages = (notificaciones.length / itemsPerPage).ceil(); // Total de páginas

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencias del Alumno'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notificaciones.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron notificaciones de asistencia.',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: (currentPage + 1) * itemsPerPage > notificaciones.length
                              ? notificaciones.length % itemsPerPage
                              : itemsPerPage,
                          itemBuilder: (context, index) {
                            int actualIndex = index + currentPage * itemsPerPage;
                            final notificacion = notificaciones[actualIndex];
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), // Bordes redondeados
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.notifications,
                                              color: Colors.green, size: 30),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              notificacion['subject_notificacion'],
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        notificacion['message_notificacion'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today,
                                              color: Colors.black54, size: 20),
                                          const SizedBox(width: 5),
                                          Text(
                                            'Fecha: ${notificacion['fecha_notificaciones']}',
                                            style: const TextStyle(
                                              color: Colors.black54,
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
                      // Controles de paginación
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
      ),
    );
  }
}
