import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart'; // Importa la librería para generar códigos QR
import 'package:edu_control_movile/Api/api.dart';

class CredencialAlumnoScreen extends StatefulWidget {
  final int idUsuario;

  const CredencialAlumnoScreen({super.key, required this.idUsuario});

  @override
  _CredencialAlumnoScreenState createState() => _CredencialAlumnoScreenState();
}

class _CredencialAlumnoScreenState extends State<CredencialAlumnoScreen> {
  bool isLoading = true;
  Map<String, dynamic>? alumnoData;

  @override
  void initState() {
    super.initState();
    _fetchAlumnoData();
  }

  // Función para obtener la credencial desde la API
  Future<void> _fetchAlumnoData() async {
    final response = await http
        .get(Uri.parse('$baseUrl/alumno/usuario/${widget.idUsuario}'));

    if (response.statusCode == 200) {
      setState(() {
        alumnoData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener la credencial: ${response.statusCode}');
    }
  }

  // Función para generar el string con toda la información del alumno
  String _generateQrData(Map<String, dynamic> data) {
    return '''
ID: ${data['id_alumnos']}
Nombre Completo: ${data['nombre_alumnos']} ${data['app_alumnos']} ${data['apm_alumnos']}
Grado: ${data['grado']}
Grupo: ${data['grupo']}
Carrera Técnica: ${data['carrera_tecnica']}
Fecha de Nacimiento: ${data['fecha_nacimiento_alumnos']}
CURP: ${data['curp_alumnos']}
Seguro Social: ${data['seguro_social_alumnos']}
Teléfono: ${data['telefono_alumnos']}
Comunidad: ${data['comunidad_alumnos']}
Estado: ${data['estado']}
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : alumnoData == null
              ? const Center(
                  child: Text('No se encontró información del alumno.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Container(
                      width: 320,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E), // Fondo oscuro
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Muestra la imagen del alumno o una imagen por defecto
                          alumnoData!['foto_alumnos'] != null
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundImage: MemoryImage(base64Decode(
                                      alumnoData!['foto_alumnos'])),
                                )
                              : const CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey,
                                  child: Icon(Icons.person,
                                      size: 50, color: Colors.white),
                                ),
                          const SizedBox(height: 20),
                          // Información del alumno con un estilo futurista
                          Text(
                            '${alumnoData!['nombre_alumnos']} ${alumnoData!['app_alumnos']} ${alumnoData!['apm_alumnos']}',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Grado: ${alumnoData!['grado']}',
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Grupo: ${alumnoData!['grupo']}',
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Carrera: ${alumnoData!['carrera_tecnica']}',
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          // Generación del código QR único para el alumno centrado
                          Center(
                            child: QrImageView(
                              data: _generateQrData(
                                  alumnoData!), // Incluye toda la información en el QR
                              version: QrVersions.auto,
                              size: 200.0, // Ajuste del tamaño
                              backgroundColor:
                                  Colors.white, // Fondo blanco para contraste
                              foregroundColor: Colors.black, // Contenido negro
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color:
                                    Colors.black, // Color para los ojos del QR
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors
                                    .black, // Color para el contenido del QR
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
