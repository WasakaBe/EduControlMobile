import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';  // Importa el archivo con la URL base

class TransportesTableAdminScreen extends StatefulWidget {
  @override
  _TransportesTableAdminScreenState createState() => _TransportesTableAdminScreenState();
}

class _TransportesTableAdminScreenState extends State<TransportesTableAdminScreen> {
  List<dynamic> transportes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransportes();  // Llamamos la función para cargar los transportes
  }

  // Función para obtener todos los transportes de la API
  Future<void> _fetchTransportes() async {
    final url = '$baseUrl/traslado_transporte';  // Utilizamos la baseUrl definida en api.dart

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          transportes = json.decode(response.body);  // Decodificamos la respuesta JSON
          isLoading = false;  // Terminamos la carga
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error al cargar transportes: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para agregar un nuevo traslado de transporte
  Future<void> _addTransporte(String nombreTransporte) async {
    final url = '$baseUrl/traslado_transporte/insert';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'nombre_traslado_transporte': nombreTransporte}),
      );

      if (response.statusCode == 201) {
        _fetchTransportes();  // Recargamos la lista después de agregar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transporte agregado exitosamente')),
        );
      } else {
        print('Error al agregar el transporte: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  // Función para eliminar un transporte por ID
  Future<void> _deleteTransporte(int idTransporte) async {
    final url = '$baseUrl/traslado_transporte/$idTransporte';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        _fetchTransportes();  // Recargamos la lista después de eliminar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transporte eliminado exitosamente')),
        );
      } else {
        print('Error al eliminar el transporte: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al conectarse con el servidor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Transportes'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Mostramos un indicador de carga
          : ListView.builder(
              itemCount: transportes.length,  // Contamos los transportes cargados
              itemBuilder: (context, index) {
                final transporte = transportes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text('${transporte['nombre_traslado_transporte']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteTransporte(transporte['id_traslado_transporte']);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransporteDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Diálogo para agregar un nuevo transporte
  void _showAddTransporteDialog() {
    String nombreTransporte = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Transporte"),
          content: TextField(
            onChanged: (value) {
              nombreTransporte = value;
            },
            decoration: InputDecoration(hintText: "Nombre del Transporte"),
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
                _addTransporte(nombreTransporte);  // Llamamos la función para agregar
              },
            ),
          ],
        );
      },
    );
  }
}
