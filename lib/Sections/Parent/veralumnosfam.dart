import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'horarioescolarfam.dart';
import 'notificacionfam.dart'; // Importar la nueva pantalla de notificaciones
import 'package:edu_control_movile/Api/api.dart';

class VerAlumnosFamScreen extends StatefulWidget {
  final int idUsuario;

  const VerAlumnosFamScreen({Key? key, required this.idUsuario})
      : super(key: key);

  @override
  _VerAlumnosFamScreenState createState() => _VerAlumnosFamScreenState();
}

class _VerAlumnosFamScreenState extends State<VerAlumnosFamScreen> {
  bool isLoading = false;
  List<dynamic> alumnos = [];

  @override
  void initState() {
    super.initState();
    _fetchAlumnosAgregados();
  }

  // Función para obtener los alumnos agregados
  Future<void> _fetchAlumnosAgregados() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse('$baseUrl/alumnos_agregados/view/${widget.idUsuario}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          alumnos = data;
        });
      } else {
        _showAlert('Error al obtener los alumnos agregados.');
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

  // Redirigir a la pantalla de HorarioEscolarFamScreen
  void _verHorario(int idAlumno) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HorarioEscolarFamScreen(idAlumno: idAlumno),
      ),
    );
  }

  // Redirigir a la pantalla de NotificacionFamScreen
  void _verNotificaciones(int idAlumno) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificacionFamScreen(idAlumno: idAlumno),
      ),
    );
  }

  // Función para eliminar un alumno
  Future<void> _eliminarAlumno(int idAlumno) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/alumnos_agregados/delete'),
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({'id_usuario': widget.idUsuario, 'id_alumno': idAlumno}),
      );

      if (response.statusCode == 200) {
        _showAlert('Alumno eliminado exitosamente.');
        _fetchAlumnosAgregados(); // Actualizar la lista de alumnos
      } else {
        _showAlert('Error al eliminar el alumno.');
      }
    } catch (e) {
      _showAlert('Error al conectarse con el servidor.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : alumnos.isEmpty
                ? const Center(child: Text('No se han agregado alumnos.'))
                : ListView.builder(
                    itemCount: alumnos.length,
                    itemBuilder: (context, index) {
                      final alumno = alumnos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black38,
                        color: const Color(0xFF393E46),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: alumno['foto_usuario'] != null
                                    ? CircleAvatar(
                                        radius: 30,
                                        backgroundImage: MemoryImage(
                                            base64Decode(
                                                alumno['foto_usuario'])),
                                      )
                                    : const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.person,
                                            color: Colors.white),
                                      ),
                                title: Text(
                                  '${alumno['nombre_alumnos']} ${alumno['app_alumnos']} ${alumno['apm_alumnos']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text(
                                      'Carrera: ${alumno['carrera_tecnica']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      'Grado y Grupo: ${alumno['grado']} º ${alumno['grupo']}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Usamos Wrap para que los botones se ajusten bien en diferentes tamaños de pantalla
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _buildButton('Horario Escolar', Colors.teal,
                                      () {
                                    _verHorario(alumno['id_alumnos']);
                                  }),
                                  _buildButton('Notificaciones', Colors.amber,
                                      () {
                                    _verNotificaciones(alumno['id_alumnos']);
                                  }),
                                  _buildButton('Eliminar', Colors.red, () {
                                    _eliminarAlumno(alumno['id_alumnos']);
                                  }),
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

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 4,
        shadowColor: Colors.black54,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
