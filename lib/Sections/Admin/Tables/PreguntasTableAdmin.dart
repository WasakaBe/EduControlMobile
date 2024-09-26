import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';  // Importa el archivo con la URL base

class PreguntasTableAdminScreen extends StatefulWidget {
  @override
  _PreguntasTableAdminScreenState createState() => _PreguntasTableAdminScreenState();
}

class _PreguntasTableAdminScreenState extends State<PreguntasTableAdminScreen> {
  List<dynamic> preguntas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPreguntas();  // Llamamos la función para cargar las preguntas
  }

  // Función para obtener todas las preguntas de la API
  Future<void> _fetchPreguntas() async {
    final url = '$baseUrl/pregunta';  // Utilizamos la baseUrl definida en api.dart

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          preguntas = json.decode(response.body);  // Decodificamos la respuesta JSON
          isLoading = false;  // Terminamos la carga
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error al cargar preguntas: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para agregar una nueva pregunta
  Future<void> _addPregunta(String nombrePregunta) async {
    final url = '$baseUrl/pregunta/insert';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'nombre_preguntas': nombrePregunta}),
      );

      if (response.statusCode == 201) {
        _fetchPreguntas();  // Recargamos la lista después de agregar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pregunta agregada exitosamente')),
        );
      } else {
        print('Error al agregar la pregunta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para eliminar una pregunta por ID
  Future<void> _deletePregunta(int idPregunta) async {
    final url = '$baseUrl/pregunta/$idPregunta';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _fetchPreguntas();  // Recargamos la lista después de eliminar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pregunta eliminada exitosamente')),
        );
      } else {
        print('Error al eliminar la pregunta: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Preguntas'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Mostramos un indicador de carga
          : ListView.builder(
              itemCount: preguntas.length,  // Contamos las preguntas cargadas
              itemBuilder: (context, index) {
                final pregunta = preguntas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text('${pregunta['nombre_preguntas']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deletePregunta(pregunta['id_preguntas']);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPreguntaDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Diálogo para agregar una nueva pregunta
  void _showAddPreguntaDialog() {
    String nombrePregunta = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Pregunta"),
          content: TextField(
            onChanged: (value) {
              nombrePregunta = value;
            },
            decoration: InputDecoration(hintText: "Nombre de la Pregunta"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Agregar"),
              onPressed: () {
                Navigator.of(context).pop();
                _addPregunta(nombrePregunta);  // Llamamos la función para agregar
              },
            ),
          ],
        );
      },
    );
  }
}
