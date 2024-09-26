import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';
import 'package:edu_control_movile/Sections/Parent/veralumnosfam.dart'; // Importar la pantalla veralumnosfam.dart

class AgregarAlumnoScreen extends StatefulWidget {
  final int idUsuario;

  const AgregarAlumnoScreen({Key? key, required this.idUsuario}) : super(key: key);

  @override
  _AgregarAlumnoScreenState createState() => _AgregarAlumnoScreenState();
}

class _AgregarAlumnoScreenState extends State<AgregarAlumnoScreen> {
  final TextEditingController _numeroControlController = TextEditingController();
  bool isLoading = false;
  bool alumnoFound = false;

  // Información del alumno
  String? alumnoInfo;
  String? carrera;
  String? gradoGrupo;
  String? fotoBase64;
  int? idAlumno;

  // Función para buscar alumno por número de control
  Future<void> _buscarAlumno() async {
    setState(() {
      isLoading = true;
      alumnoFound = false;
      alumnoInfo = null;
      carrera = null;
      gradoGrupo = null;
      fotoBase64 = null;
      idAlumno = null;
    });

    final String numeroControl = _numeroControlController.text;

    if (numeroControl.isEmpty) {
      _showAlert('Por favor, ingrese el número de control.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse('$baseUrl/alumnos/nocontrol/$numeroControl'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Guardamos los detalles adicionales
          alumnoInfo = '${data['nombre_alumnos']} ${data['app_alumnos']} ${data['apm_alumnos']}';
          carrera = data['carrera_tecnica'];
          gradoGrupo = '${data['grado']} º ${data['grupo']}';
          fotoBase64 = data['foto_usuario'];
          idAlumno = data['id_alumnos'];
          alumnoFound = true;  // Alumno encontrado
        });
      } else {
        _showAlert('Alumno no encontrado.');
      }
    } catch (e) {
      _showAlert('Error al buscar el alumno.');
    }

    setState(() {
      isLoading = false;
    });
  }

  // Función para agregar alumno
  Future<void> _agregarAlumno() async {
    if (idAlumno == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alumnos_agregados/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_usuario': widget.idUsuario,
          'id_alumno': idAlumno,
        }),
      );

      if (response.statusCode == 201) {
        // Si el alumno se agrega correctamente, redirige a veralumnosfam.dart
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerAlumnosFamScreen(idUsuario: widget.idUsuario),
          ),
        );
      } else {
        _showAlert('Error al agregar el alumno.');
      }
    } catch (e) {
      _showAlert('Error al intentar agregar el alumno.');
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
  
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Ingrese el número de control del alumno',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _numeroControlController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Número de Control',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _buscarAlumno,
                    child: const Text('Buscar Alumno'),
                  ),
            const SizedBox(height: 20),
            if (alumnoInfo != null)
              Column(
                children: [
                  // Mostrar la foto de perfil si existe
                  if (fotoBase64 != null)
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: MemoryImage(base64Decode(fotoBase64!)),
                    ),
                  const SizedBox(height: 20),
                  // Información del alumno
                  Text(
                    'Alumno encontrado: $alumnoInfo',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  const SizedBox(height: 10),
                  // Mostrar carrera
                  Text(
                    'Carrera: $carrera',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 5),
                  // Mostrar grado y grupo
                  Text(
                    'Grado y Grupo: $gradoGrupo',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  // Botones de Agregar y Cancelar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _agregarAlumno,
                        child: const Text('Agregar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Regresar a la pantalla anterior
                        },
                        child: const Text('Cancelar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
