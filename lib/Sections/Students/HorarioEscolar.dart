import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:edu_control_movile/Api/api.dart';

class HorarioEscolarScreen extends StatefulWidget {
  final int idUsuario;

  const HorarioEscolarScreen({super.key, required this.idUsuario});

  @override
  _HorarioEscolarScreenState createState() => _HorarioEscolarScreenState();
}

class _HorarioEscolarScreenState extends State<HorarioEscolarScreen> {
  bool isLoading = true;
  List<dynamic> asignaturas = [];

  @override
  void initState() {
    super.initState();
    _fetchAsignaturas();
  }

  // Función para obtener las asignaturas desde la API
  Future<void> _fetchAsignaturas() async {
    final response = await http
        .get(Uri.parse('$baseUrl/asignaturas/alumno/id/${widget.idUsuario}'));

    if (response.statusCode == 200) {
      setState(() {
        asignaturas = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener las asignaturas: ${response.statusCode}');
    }
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
                                'Grado: ${asignatura['nombre_grado']}  Grupo: ${asignatura['nombre_grupo']}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Carrera: ${asignatura['nombre_carrera_tecnica']}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Ciclo Escolar: ${asignatura['ciclo_escolar']}',
                                style: TextStyle(
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
