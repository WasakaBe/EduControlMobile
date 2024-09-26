import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Para manejar el archivo de imagen
import 'package:image_picker/image_picker.dart'; // Paquete para seleccionar imágenes
import 'package:edu_control_movile/Api/api.dart'; // Importa la base URL

class CarruselAdmin extends StatefulWidget {
  const CarruselAdmin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CarruselAdminState createState() => _CarruselAdminState();
}

class _CarruselAdminState extends State<CarruselAdmin> {
  List<dynamic> carruselImgs = [];
  bool isLoading = true;
  final ImagePicker _picker = ImagePicker(); // Inicializamos el picker de imágenes
  File? _image; // Para almacenar temporalmente la imagen seleccionada

  @override
  void initState() {
    super.initState();
    _fetchCarruselImgs();
  }

  // Función para obtener todas las imágenes del carrusel de la API
  Future<void> _fetchCarruselImgs() async {
    final url = '$baseUrl/carrusel_imgs';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          carruselImgs = json.decode(response.body)['carrusel_imgs'];
          isLoading = false;
        });
      } else {
        // ignore: avoid_print
        print('Error al cargar imágenes: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error al conectarse con el servidor: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para seleccionar una imagen
  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      // ignore: avoid_print
      print('No seleccionaste ninguna imagen');
    }
  }

  // Función para insertar una nueva imagen en el carrusel
  Future<void> _insertCarruselImg() async {
    if (_image != null) {
      // Convertir imagen a base64
      final bytes = await _image!.readAsBytes();
      String base64Image = base64Encode(bytes);

      const url = '$baseUrl/carrusel_imgs/insert';
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'carrusel': base64Image}),
      );

      if (response.statusCode == 201) {
        _fetchCarruselImgs(); // Recargamos las imágenes
        Navigator.of(context).pop(); // Cerrar la modal después de insertar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Imagen del carrusel insertada exitosamente'),
            backgroundColor: Colors.green));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Error al insertar imagen del carrusel'),
            backgroundColor: Colors.red));
      }
    }
  }

  // Función para mostrar la modal de insertar imagen
  Future<void> _showInsertImageModal() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Insertar nueva imagen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _image != null
                  ? Image.file(_image!)
                  : const Text('Selecciona una imagen'),
              ElevatedButton(
                onPressed: _selectImage,
                child: const Text('Seleccionar imagen'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar la modal
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: _insertCarruselImg,
              child: const Text('Insertar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrusel Admin'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: carruselImgs.length,
              itemBuilder: (context, index) {
                final img = carruselImgs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    title: Text('ID: ${img['id_carrusel']}'),
                    subtitle: img['carrusel'] != null
                        ? Image.memory(base64Decode(img['carrusel']))
                        : const Text('No image available'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInsertImageModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
