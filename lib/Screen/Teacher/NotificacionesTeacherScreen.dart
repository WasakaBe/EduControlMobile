import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movil_educontrol/Api/api.dart';

class NotificacionesTeacherScreen extends StatefulWidget {
  final int userId; // El ID del usuario se pasa como argumento

  const NotificacionesTeacherScreen({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _NotificacionesTeacherScreenState createState() => _NotificacionesTeacherScreenState();
}

class _NotificacionesTeacherScreenState extends State<NotificacionesTeacherScreen> {
  List<dynamic> _notificaciones = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNotificaciones();
  }

  Future<void> _fetchNotificaciones() async {
    final url = '$baseUrl/notificaciones_docentes/user_docente/${widget.userId}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map && data.containsKey('message')) {
          setState(() {
            _errorMessage = data['message'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _notificaciones = data;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Error: ${response.body}';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error de conexión: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _notificaciones.isEmpty
                  ? const Center(child: Text('No hay notificaciones'))
                  : ListView.builder(
                      itemCount: _notificaciones.length,
                      itemBuilder: (context, index) {
                        final notificacion = _notificaciones[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.notifications, color: Colors.green),
                              title: Text(
                                notificacion['subject_notificacion_doc'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  Text(notificacion['message_notificacion_doc']),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Fecha: ${notificacion['fecha_notificaciones_doc']}',
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                           
                              onTap: () {
                                _showNotificacionDetails(context, notificacion);
                              },
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  // Mostrar los detalles de la notificación en un modal
  void _showNotificacionDetails(BuildContext context, Map<String, dynamic> notificacion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notificacion['subject_notificacion_doc']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mensaje: ${notificacion['message_notificacion_doc']}'),
            const SizedBox(height: 10),
            Text('Fecha: ${notificacion['fecha_notificaciones_doc']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
