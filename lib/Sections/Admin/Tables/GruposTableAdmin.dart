import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';  // Importa el archivo con la URL base

class GruposTableAdminScreen extends StatefulWidget {
  @override
  _GruposTableAdminScreenState createState() => _GruposTableAdminScreenState();
}

class _GruposTableAdminScreenState extends State<GruposTableAdminScreen> {
  List<dynamic> grupos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGrupos();  // Llamamos la función para cargar los grupos
  }

  // Función para obtener todos los grupos de la API
  Future<void> _fetchGrupos() async {
    final url = '$baseUrl/grupo';  // Utilizamos la baseUrl definida en api.dart

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          grupos = json.decode(response.body);  // Decodificamos la respuesta JSON
          isLoading = false;  // Terminamos la carga
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error al cargar grupos: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para agregar un nuevo grupo
  Future<void> _addGrupo(String nombreGrupo) async {
    final url = '$baseUrl/grupo/insert';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'nombre_grupos': nombreGrupo}),
      );

      if (response.statusCode == 201) {
        _fetchGrupos();  // Recargamos la lista después de agregar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grupo agregado exitosamente')),
        );
      } else {
        print('Error al agregar el grupo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para eliminar un grupo por ID
  Future<void> _deleteGrupo(int idGrupo) async {
    final url = '$baseUrl/grupo/$idGrupo';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _fetchGrupos();  // Recargamos la lista después de eliminar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Grupo eliminado exitosamente')),
        );
      } else {
        print('Error al eliminar el grupo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Grupos'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Mostramos un indicador de carga
          : ListView.builder(
              itemCount: grupos.length,  // Contamos los grupos cargados
              itemBuilder: (context, index) {
                final grupo = grupos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text('${grupo['nombre_grupos']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteGrupo(grupo['id_grupos']);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGrupoDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Diálogo para agregar un nuevo grupo
  void _showAddGrupoDialog() {
    String nombreGrupo = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Grupo"),
          content: TextField(
            onChanged: (value) {
              nombreGrupo = value;
            },
            decoration: InputDecoration(hintText: "Nombre del Grupo"),
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
                _addGrupo(nombreGrupo);  // Llamamos la función para agregar
              },
            ),
          ],
        );
      },
    );
  }
}
