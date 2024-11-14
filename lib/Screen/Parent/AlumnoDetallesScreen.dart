import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movil_educontrol/Api/api.dart';
import 'package:movil_educontrol/Components/Feedback/Feedback.dart';

class AlumnoDetallesScreen extends StatefulWidget {
  final int idAlumno;

  const AlumnoDetallesScreen({super.key, required this.idAlumno});

  @override
  _AlumnoDetallesScreenState createState() => _AlumnoDetallesScreenState();
}

class _AlumnoDetallesScreenState extends State<AlumnoDetallesScreen> {
  bool isLoading = true;
  List<dynamic> asignaturas = [];

  @override
  void initState() {
    super.initState();
    _fetchHorario();
  }

  // Función para obtener las asignaturas del alumno desde la nueva API
  Future<void> _fetchHorario() async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/asignatura/horario/escolar/${widget.idAlumno}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          asignaturas = data['asignaturas'];
          isLoading = false;
        });
      } else {
        _showAlert('Error al obtener el horario escolar.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      _showAlert('Error al conectarse con el servidor.');
      setState(() {
        isLoading = false;
      });
    }
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

  // Muestra el horario y detalles de cada asignatura
  Widget _buildAsignaturaCard(dynamic asignatura) {
    List<dynamic> diasHorarios = asignatura['dias_horarios'] ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              asignatura['nombre_asignatura'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Docente: ${asignatura['nombre_docente']}',
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.teal),
                const SizedBox(width: 8),
                Text('Ciclo Escolar: ${asignatura['ciclo_escolar']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.school, color: Colors.teal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Carrera Técnica: ${asignatura['nombre_carrera_tecnica']}',
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Mostrar los días y horas si están disponibles
            diasHorarios.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: diasHorarios.map((diaHorario) {
                      return Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.teal),
                          const SizedBox(width: 8),
                          Text(
                              '${diaHorario['day']}: ${diaHorario['startTime']} - ${diaHorario['endTime']}'),
                        ],
                      );
                    }).toList(),
                  )
                : const Text('No hay horarios asignados'),
          ],
        ),
      ),
    );
  }

  // Función para cerrar la pantalla y mostrar el feedback
  Future<void> _salirYMostrarFeedback() async {
    Navigator.pop(context);
    // Mostrar el modal de feedback después de cerrar la pantalla
    FeedbackModal.showFeedbackModal(context, widget.idAlumno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario Escolar'),
          automaticallyImplyLeading: false, // Ocultar la flecha de regreso
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _salirYMostrarFeedback, // Llama a la función para salir y mostrar el feedback
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : asignaturas.isEmpty
                ? const Center(child: Text('No se encontraron asignaturas.'))
                : ListView.builder(
                    itemCount: asignaturas.length,
                    itemBuilder: (context, index) {
                      final asignatura = asignaturas[index];
                      return _buildAsignaturaCard(asignatura);
                    },
                  ),
      ),
    );
  }
}
