import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movil_educontrol/Api/api.dart';

class HorarioStudentScreen extends StatefulWidget {
  final int idUsuario;

  const HorarioStudentScreen({super.key, required this.idUsuario});

  @override
  _HorarioStudentScreenState createState() => _HorarioStudentScreenState();
}

class _HorarioStudentScreenState extends State<HorarioStudentScreen> {
  bool isLoading = true;
  List<dynamic> asignaturas = [];

  @override
  void initState() {
    super.initState();
    _fetchAsignaturas();
  }

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

  void _showInfoDocente(BuildContext context, dynamic docenteData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final mediaQuery = MediaQuery.of(context);

        return WillPopScope(
          onWillPop: () async => false, // Bloquear el deslizamiento hacia atrás
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Información del Docente',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  docenteData['docente_foto'] != null
                      ? CircleAvatar(
                          radius: mediaQuery.size.width * 0.15,
                          backgroundImage:
                              MemoryImage(base64Decode(docenteData['docente_foto'])),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Nombre: ${docenteData['nombre_docente']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Correo: ${docenteData['docente_email'] ?? 'No disponible'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Teléfono: ${docenteData['docente_telefono'] ?? 'No disponible'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.teal),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Bloquear permanentemente el deslizamiento
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : asignaturas.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron asignaturas',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: asignaturas.length,
                    itemBuilder: (context, index) {
                      final asignatura = asignaturas[index];
                      List<dynamic> diasHorarios =
                          asignatura['dias_horarios'] ?? [];

                      return Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                asignatura['nombre_asignatura'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.person, color: Colors.green[700], size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Docente: ${asignatura['nombre_docente']}',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.green[700], size: 20),
                                  const SizedBox(width: 8),
                                  for (var dia in diasHorarios)
                                    Text(
                                      '${dia['day']}: ${dia['startTime']} - ${dia['endTime']}',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    _showInfoDocente(context, asignatura);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text(
                                    'Info Docente',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
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
