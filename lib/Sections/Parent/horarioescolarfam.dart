import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edu_control_movile/Api/api.dart';

class HorarioEscolarFamScreen extends StatefulWidget {
  final int idAlumno;

  const HorarioEscolarFamScreen({Key? key, required this.idAlumno})
      : super(key: key);

  @override
  _HorarioEscolarFamScreenState createState() =>
      _HorarioEscolarFamScreenState();
}

class _HorarioEscolarFamScreenState extends State<HorarioEscolarFamScreen> {
  bool isLoading = false;
  List<dynamic> asignaturas = [];

  @override
  void initState() {
    super.initState();
    _fetchHorarioEscolar();
  }

  // Función para obtener el horario escolar del alumno
  Future<void> _fetchHorarioEscolar() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse('$baseUrl/asignatura/horario/escolar/${widget.idAlumno}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          asignaturas = data['asignaturas'];
        });
      } else {
        _showAlert('Error al obtener el horario escolar.');
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : asignaturas.isEmpty
              ? const Center(
                  child: Text(
                    'No se encontraron asignaturas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Container(
                  color: Colors.black, // Fondo negro futurista
                  child: ListView.builder(
                    itemCount: asignaturas.length,
                    itemBuilder: (context, index) {
                      final asignatura = asignaturas[index];
                      List<dynamic> diasHorarios =
                          asignatura['dias_horarios'] ?? [];

                      return Card(
                        color: Colors.grey[900],
                        elevation: 8,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                asignatura['nombre_asignatura'],
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Docente: ${asignatura['nombre_docente']}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Carrera: ${asignatura['nombre_carrera_tecnica']}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Ciclo Escolar: ${asignatura['ciclo_escolar']}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Días y Horarios:',
                                style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              for (var dia in diasHorarios)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Día: ${dia['day']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Inicio: ${dia['startTime']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Termina: ${dia['endTime']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
