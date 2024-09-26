import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart'; // Importa la base URL

class AsignaturasTableAdminScreen extends StatefulWidget {
  @override
  _AsignaturasTableAdminScreenState createState() =>
      _AsignaturasTableAdminScreenState();
}

class _AsignaturasTableAdminScreenState
    extends State<AsignaturasTableAdminScreen> {
  List<dynamic> asignaturas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAsignaturas();
  }

  // Función para obtener todas las asignaturas de la API
  Future<void> _fetchAsignaturas() async {
    final url = '$baseUrl/asignatura';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          asignaturas = json.decode(response.body)['asignaturas'];
          isLoading = false;
        });
      } else {
        print('Error al cargar asignaturas: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para crear una nueva asignatura
  Future<void> _createAsignatura(String nombre) async {
    final url = '$baseUrl/asignatura/insert';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nombre_asignatura': nombre}),
    );

    if (response.statusCode == 201) {
      _fetchAsignaturas(); // Recargamos las asignaturas
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Asignatura creada exitosamente'),
          backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al crear asignatura'),
          backgroundColor: Colors.red));
    }
  }

  // Función para eliminar una asignatura
  Future<void> _deleteAsignatura(int id) async {
    final url = '$baseUrl/asignatura/$id';
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      _fetchAsignaturas(); // Recargamos las asignaturas
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Asignatura eliminada exitosamente'),
          backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al eliminar asignatura'),
          backgroundColor: Colors.red));
    }
  }

  // Función para actualizar una asignatura
  Future<void> _updateAsignatura(int id, String nuevoNombre) async {
    final url = '$baseUrl/asignatura/$id';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nombre_asignatura': nuevoNombre}),
    );

    if (response.statusCode == 200) {
      _fetchAsignaturas(); // Recargamos las asignaturas
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Asignatura actualizada exitosamente'),
          backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al actualizar asignatura'),
          backgroundColor: Colors.red));
    }
  }

  // Mostrar diálogo para crear o editar asignaturas
  Future<void> _showAsignaturaDialog({int? id, String? nombreActual}) async {
    TextEditingController _nombreController =
        TextEditingController(text: nombreActual ?? '');

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(id == null ? 'Agregar Asignatura' : 'Editar Asignatura'),
            content: TextField(
              controller: _nombreController,
              decoration: InputDecoration(hintText: 'Nombre de la asignatura'),
            ),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(id == null ? 'Crear' : 'Actualizar'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (id == null) {
                    _createAsignatura(_nombreController.text);
                  } else {
                    _updateAsignatura(id, _nombreController.text);
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asignaturas'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: asignaturas.length,
              itemBuilder: (context, index) {
                final asignatura = asignaturas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text(asignatura['nombre_asignatura']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showAsignaturaDialog(
                                id: asignatura['id_asignatura'],
                                nombreActual: asignatura['nombre_asignatura']);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteAsignatura(asignatura['id_asignatura']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAsignaturaDialog(); // Agregar una nueva asignatura
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
