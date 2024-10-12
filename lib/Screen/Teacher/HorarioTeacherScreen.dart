import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movil_educontrol/Api/api.dart';

class HorarioTeacherScreen extends StatefulWidget {
  final int idUsuario;

  const HorarioTeacherScreen({super.key, required this.idUsuario});

  @override
  // ignore: library_private_types_in_public_api
  _HorarioTeacherScreenState createState() => _HorarioTeacherScreenState();
}

class _HorarioTeacherScreenState extends State<HorarioTeacherScreen> {
  List<dynamic> _horarios = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchHorarios();
  }

  Future<void> _fetchHorarios() async {
    final url = '$baseUrl/horarios_escolares/docente/${widget.idUsuario}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _horarios = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error: ${response.body}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error de conexión: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAlumnosByHorario(int idHorario) async {
    final url = '$baseUrl/alumnos/horario/$idHorario';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final alumnos = jsonDecode(response.body);
        if (alumnos.isEmpty) {
          // ignore: use_build_context_synchronously
          _showDialog(context, 'No hay alumnos para este horario');
        } else {
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => AlumnosListScreen(alumnos: alumnos),
            ),
          );
        }
      } else {
        // ignore: use_build_context_synchronously
        _showDialog(context, 'Error al obtener los alumnos');
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      _showDialog(context, 'Error de conexión: $error');
    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _horarios.length,
                  itemBuilder: (context, index) {
                    final horario = _horarios[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                horario['nombre_asignatura'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Docente: ${horario['nombre_docente']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.schedule,
                                      color: Colors.green),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _formatDias(horario['dias_horarios']),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _fetchAlumnosByHorario(
                                        horario['id_horario']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text('Ver Alumnos'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _formatDias(List<dynamic> dias) {
    if (dias.isEmpty) return 'Sin horarios';
    List<String> diasFormatted = [];
    for (var dia in dias) {
      final String day = dia['day'];
      final String startTime = dia['startTime'];
      final String endTime = dia['endTime'];
      diasFormatted.add('$day: $startTime - $endTime');
    }
    return diasFormatted.join(', ');
  }
}

// Pantalla para mostrar la lista de alumnos
class AlumnosListScreen extends StatelessWidget {
  final List<dynamic> alumnos;

  const AlumnosListScreen({super.key, required this.alumnos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         automaticallyImplyLeading: false, 
        title: const Text(
          'Alumnos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(221, 12, 39, 28),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app , color: Colors.white),
            onPressed: () {
              Navigator.pop(
                  context); // Al presionar el botón, se cierra la pantalla
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: alumnos.length,
          itemBuilder: (context, index) {
            final alumno = alumnos[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: alumno['foto_alumnos'] != null
                      ? MemoryImage(base64Decode(alumno['foto_alumnos']))
                      : null,
                  radius: 30,
                  backgroundColor: Colors.green.shade100,
                  child: alumno['foto_alumnos'] == null
                      ? const Icon(Icons.person, size: 30)
                      : null,
                ),
                title: Text(
                  '${alumno['nombre_alumnos']} ${alumno['app_alumnos']} ${alumno['apm_alumnos']}',
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text(
                  'No. Control: ${alumno['nocontrol_alumnos']}\n'
                  'Carrera: ${alumno['nombre_carrera_tecnica']}\n'
                  'Grado: ${alumno['nombre_grado']} - Grupo: ${alumno['nombre_grupo']}',
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: ElevatedButton(
                  onPressed: () {
                    _fetchAlumnoContacto(context, alumno['id_alumnos']);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromARGB(221, 12, 39, 28),
                  ),
                  child: const Text(
                    'Contacto Familiar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _fetchAlumnoContacto(BuildContext context, int idAlumno) async {
    final url = '$baseUrl/alumno/$idAlumno';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final alumno = jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        _showContactoFamiliar(context, alumno);
      } else {
        // ignore: use_build_context_synchronously
        _showDialog(context, 'Error al obtener el contacto familiar');
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      _showDialog(context, 'Error de conexión: $error');
    }
  }

  void _showContactoFamiliar(
    BuildContext context, Map<String, dynamic> alumno) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.family_restroom, color: Colors.green), // Icono para el título
          const SizedBox(width: 10),
          Text(
            'Contacto Familiar de ${alumno['nombre_alumnos']}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.person, color: Colors.green), // Icono de persona
              const SizedBox(width: 10),
              Text(
                'Familiar: ${alumno['nombre_completo_familiar']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.green), // Icono de teléfono
              const SizedBox(width: 10),
              Text(
                'Teléfono: ${alumno['telefono_familiar']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.work, color: Colors.green), // Icono de trabajo
              const SizedBox(width: 10),
              Text(
                'Teléfono Trabajo: ${alumno['telefono_trabajo_familiar']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.email, color: Colors.green), // Icono de correo
              const SizedBox(width: 10),
              Text(
                'Correo: ${alumno['correo_familiar']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cerrar',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}


  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
