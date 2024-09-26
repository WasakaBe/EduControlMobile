import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';  // Importa el archivo con la URL base

class TrasladosTableAdminScreen extends StatefulWidget {
  @override
  _TrasladosTableAdminScreenState createState() => _TrasladosTableAdminScreenState();
}

class _TrasladosTableAdminScreenState extends State<TrasladosTableAdminScreen> {
  List<dynamic> traslados = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTraslados();  // Llamamos la función para cargar los traslados
  }

  // Función para obtener todos los traslados de la API
  Future<void> _fetchTraslados() async {
    final url = '$baseUrl/traslado';  // Utilizamos la baseUrl definida en api.dart

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          traslados = json.decode(response.body);  // Decodificamos la respuesta JSON
          isLoading = false;  // Terminamos la carga
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error al cargar traslados: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para agregar un nuevo traslado
  Future<void> _addTraslado(String nombreTraslado) async {
    final url = '$baseUrl/traslado/insert';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'nombre_traslado': nombreTraslado}),
      );

      if (response.statusCode == 201) {
        _fetchTraslados();  // Recargamos la lista después de agregar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Traslado agregado exitosamente')),
        );
      } else {
        print('Error al agregar el traslado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para eliminar un traslado por ID
  Future<void> _deleteTraslado(int idTraslado) async {
    final url = '$baseUrl/traslado/$idTraslado';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _fetchTraslados();  // Recargamos la lista después de eliminar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Traslado eliminado exitosamente')),
        );
      } else {
        print('Error al eliminar el traslado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Traslados'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Mostramos un indicador de carga
          : ListView.builder(
              itemCount: traslados.length,  // Contamos los traslados cargados
              itemBuilder: (context, index) {
                final traslado = traslados[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text('${traslado['nombre_traslado']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteTraslado(traslado['id_traslado']);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTrasladoDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Diálogo para agregar un nuevo traslado
  void _showAddTrasladoDialog() {
    String nombreTraslado = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Traslado"),
          content: TextField(
            onChanged: (value) {
              nombreTraslado = value;
            },
            decoration: InputDecoration(hintText: "Nombre del Traslado"),
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
                _addTraslado(nombreTraslado);  // Llamamos la función para agregar
              },
            ),
          ],
        );
      },
    );
  }
}
