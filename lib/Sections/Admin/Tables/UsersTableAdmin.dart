import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:edu_control_movile/Api/api.dart';  // Importa el archivo con la URL base

class UsersTableAdminScreen extends StatefulWidget {
  @override
  _UsersTableAdminScreenState createState() => _UsersTableAdminScreenState();
}

class _UsersTableAdminScreenState extends State<UsersTableAdminScreen> {
  List<dynamic> usuarios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsuarios();  // Llamamos la función para cargar los usuarios
  }

  // Función para obtener todos los usuarios de la API
  Future<void> _fetchUsuarios() async {
    final url = '$baseUrl/usuario';  // Utilizamos la baseUrl definida en api.dart

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          usuarios = json.decode(response.body);  // Decodificamos la respuesta JSON
          isLoading = false;  // Terminamos la carga
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error al cargar usuarios: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al conectarse con el servidor: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // Mostramos un indicador de carga
          : ListView.builder(
              itemCount: usuarios.length,  // Contamos los usuarios cargados
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: usuario['foto_usuario'] != null
                                ? MemoryImage(base64Decode(usuario['foto_usuario']))
                                :const AssetImage('assets/image/perfil.png') as ImageProvider,
                          ),
                          title: Text('${usuario['nombre_usuario']} ${usuario['app_usuario']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Correo: ${usuario['correo_usuario']}'),
                              SizedBox(height: 5),
                              Text('Rol: ${usuario['nombre_rol']}'), // Mostramos el tipo de rol
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Acción para "Ver más", puede ser navegar a otra pantalla o mostrar más detalles
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Detalles del usuario"),
                                    content: Text(
                                      'Nombre: ${usuario['nombre_usuario']} ${usuario['app_usuario']} \n'
                                      'Correo: ${usuario['correo_usuario']} \n'
                                      'Rol: ${usuario['nombre_rol']} \n'
                                      'Teléfono: ${usuario['phone_usuario']}',
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Cerrar"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Ver más'),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
