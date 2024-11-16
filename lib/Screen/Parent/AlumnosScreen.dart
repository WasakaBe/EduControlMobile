import 'dart:convert'; // Para decodificar Base64
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movil_educontrol/Api/api.dart';
import 'package:movil_educontrol/Components/Feedback/Feedback.dart';
import 'package:movil_educontrol/Screen/Parent/AlumnoDetallesScreen.dart';
import 'package:movil_educontrol/Screen/Parent/AsistenciasScreen.dart';

class AlumnosScreen extends StatefulWidget {
  final int idUsuario;

  const AlumnosScreen({super.key, required this.idUsuario});

  @override
  _AlumnosScreenState createState() => _AlumnosScreenState();
}

class _AlumnosScreenState extends State<AlumnosScreen> {
  bool isLoading = false;
  List<dynamic> alumnos = [];
  final TextEditingController _numeroControlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAlumnosAgregados();
  }

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

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Bloquear el deslizamiento hacia atrás
          child: AlertDialog(
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
          ),
        );
      },
    );
  }

  Future<void> _eliminarAlumno(int idAlumno) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/alumnos_agregados/delete'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_usuario': widget.idUsuario,
          'id_alumno': idAlumno,
        }),
      );

      if (response.statusCode == 200) {
        _showAlert('Alumno eliminado exitosamente.');
        _fetchAlumnosAgregados();
      } else {
        _showAlert('Error al eliminar el alumno.');
      }
    } catch (e) {
      _showAlert('Error al conectarse con el servidor.');
    }
  }

  void _mostrarConfirmacionEliminacion(BuildContext context, int idAlumno, String nombreAlumno) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Bloquear el deslizamiento hacia atrás
          child: AlertDialog(
            title: const Text('Eliminar Alumno'),
            content: Text('¿Estás seguro(a) que deseas eliminar al alumno $nombreAlumno?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Sí'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _eliminarAlumno(idAlumno);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarModalAgregarAlumno() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Bloquear el deslizamiento hacia atrás
          child: AlertDialog(
            title: const Text('Agregar Nuevo Alumno'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Ingrese el número de control del alumno'),
                const SizedBox(height: 10),
                TextField(
                  controller: _numeroControlController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Número de Control',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Agregar'),
                onPressed: () async {
                  String numeroControl = _numeroControlController.text;
                  if (numeroControl.isNotEmpty) {
                    final response = await http.get(
                      Uri.parse('$baseUrl/alumnos/nocontrol/$numeroControl'),
                    );

                    if (response.statusCode == 200) {
                      final alumnoData = json.decode(response.body);
                      await _agregarAlumno(widget.idUsuario, alumnoData['id_alumnos']);
                      Navigator.of(context).pop();
                    } else {
                      _showAlert('Alumno no encontrado.');
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _agregarAlumno(int idUsuario, int idAlumno) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alumnos_agregados/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_usuario': idUsuario,
          'id_alumno': idAlumno,
        }),
      );

      if (response.statusCode == 201) {
        _numeroControlController.clear();
        _showAlert('Alumno agregado exitosamente.');
        _fetchAlumnosAgregados();
        await FeedbackModal.showFeedbackModal(context, idUsuario);
      } else {
        _showAlert('Error al agregar el alumno.');
      }
    } catch (e) {
      _showAlert('Error al conectarse con el servidor.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Bloquear permanentemente el deslizamiento
      child: Scaffold(
        backgroundColor: Colors.grey[200],
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
                          child: Stack(
                            children: [
                              Padding(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            elevation: 4,
                                            shadowColor: Colors.black54,
                                          ),
                                          onPressed: () {
                                            _verHorario(alumno['id_alumnos']);
                                          },
                                          child: const Text(
                                            'Horario Escolar',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.amber,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            elevation: 4,
                                            shadowColor: Colors.black54,
                                          ),
                                          onPressed: () {
                                            _verAsistencias(
                                                alumno['id_alumnos']);
                                          },
                                          child: const Text(
                                            'Asistencias',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    _mostrarConfirmacionEliminacion(
                                      context,
                                      alumno['id_alumnos'],
                                      '${alumno['nombre_alumnos']} ${alumno['app_alumnos']} ${alumno['apm_alumnos']}',
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _mostrarModalAgregarAlumno,
          backgroundColor: Colors.teal,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _verHorario(int idAlumno) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlumnoDetallesScreen(idAlumno: idAlumno),
      ),
    );
  }

  void _verAsistencias(int idAlumno) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsistenciasScreen(idAlumno: idAlumno),
      ),
    );
  }
}