import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart'; // Importa la librería para generar códigos QR
import 'package:edu_control_movile/Api/api.dart';

class CredencialDocenteScreen extends StatefulWidget {
  final int idUsuario;

  const CredencialDocenteScreen({Key? key, required this.idUsuario})
      : super(key: key);

  @override
  _CredencialDocenteScreenState createState() =>
      _CredencialDocenteScreenState();
}

class _CredencialDocenteScreenState extends State<CredencialDocenteScreen> {
  String? nombreDocente;
  String? fotoBase64;
  String? sexo;
  String? clinica;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCredencialDocente();
  }

  // Función para obtener los datos del docente
  Future<void> _fetchCredencialDocente() async {
    final response = await http
        .get(Uri.parse('$baseUrl/docente/usuario/${widget.idUsuario}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        nombreDocente =
            '${data['nombre_docentes']} ${data['app_docentes']} ${data['apm_docentes']}';
        fotoBase64 = data['foto_docentes'];

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Error al obtener los datos del docente: ${response.statusCode}');
    }
  }

  // Función para generar el string con toda la información del docente para el código QR
  String _generateQrData() {
    return '''
Nombre Completo: $nombreDocente
Sexo: $sexo
Clínica: $clinica
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (fotoBase64 != null)
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: MemoryImage(base64Decode(fotoBase64!)),
                    ),
                  const SizedBox(height: 20),
                  // Información del docente
                  Text(
                    nombreDocente ?? '',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'DOCENTE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 20),
                  // Código QR generado
                  Center(
                    child: QrImageView(
                      data: _generateQrData(),
                      version: QrVersions.auto,
                      size: 150.0,
                      backgroundColor: Colors.white,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Información adicional
                ],
              ),
      ),
    );
  }
}
