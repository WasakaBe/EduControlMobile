import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';  // Importa el archivo con la URL base

class GradosTableAdminScreen extends StatefulWidget {
  @override
  _GradosTableAdminScreenState createState() => _GradosTableAdminScreenState();
}

class _GradosTableAdminScreenState extends State<GradosTableAdminScreen> {
  List<dynamic> grados = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGrados();  // Llamamos la función para cargar los grados
  }

  // Función para obtener todos los grados de la API
  Future<void> _fetchGrados() async {
    final url = '$baseUrl/grado';  // Utilizamos la baseUrl definida en api.dart

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          grados = json.decode(response.body);  // Decodificamos la respuesta JSON
          isLoading = false;  // Terminamos la carga
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error al cargar grados: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para agregar un nuevo grado
  Future<void> _addGrado(String nombreGrado) async {
    final url = '$baseUrl/grado/insert';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'nombre_grado': nombreGrado}),
      );

      if (response.statusCode == 201) {
        _fetchGrados();  // Recargamos la lista después de agregar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grado agregado exitosamente')),
        );
      } else {
        print('Error al agregar el grado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para eliminar un grado por ID
  Future<void> _deleteGrado(int idGrado) async {
    final url = '$baseUrl/grado/$idGrado';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _fetchGrados();  // Recargamos la lista después de eliminar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grado eliminado exitosamente')),
        );
      } else {
        print('Error al eliminar el grado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Grados'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Mostramos un indicador de carga
          : ListView.builder(
              itemCount: grados.length,  // Contamos los grados cargados
              itemBuilder: (context, index) {
                final grado = grados[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text('${grado['nombre_grado']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteGrado(grado['id_grado']);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGradoDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Diálogo para agregar un nuevo grado
  void _showAddGradoDialog() {
    String nombreGrado = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Grado"),
          content: TextField(
            onChanged: (value) {
              nombreGrado = value;
            },
            decoration: InputDecoration(hintText: "Nombre del Grado"),
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
                _addGrado(nombreGrado);  // Llamamos la función para agregar
              },
            ),
          ],
        );
      },
    );
  }
}
