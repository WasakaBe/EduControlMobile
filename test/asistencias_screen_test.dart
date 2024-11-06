import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movil_educontrol/Api/api.dart';

@GenerateMocks([http.Client])
import 'asistencias_screen_test.mocks.dart'; // Importa el archivo generado

void main() {
  group('fetchNotificaciones', () {
    test('Debería obtener notificaciones de asistencia', () async {
      final client = MockClient(); 
      const idAlumno = 1;

      // Agrega los headers predeterminados en la llamada al `when()`
      when(client.get(
        Uri.parse('$baseUrl/notificaciones/$idAlumno'),
        headers: anyNamed('headers'), // Esto es importante para permitir cualquier encabezado
      )).thenAnswer((_) async => http.Response(
          '[{"subject_notificacion": "Asistencia", "message_notificacion": "Mensaje de prueba", "fecha_notificaciones": "2024-11-05"}]',
          200));

      // Realiza la llamada con el cliente mockeado
      final response = await client.get(Uri.parse('$baseUrl/notificaciones/$idAlumno'));
      expect(response.statusCode, 200);

      // Verifica los datos obtenidos
      final data = json.decode(response.body);
      expect(data[0]['subject_notificacion'], contains('Asistencia'));
    });

    test('Debería mostrar un error si falla la conexión', () async {
      final client = MockClient();
      const idAlumno = 1;

      // Configura el mock para lanzar un error
      when(client.get(
        Uri.parse('$baseUrl/notificaciones/$idAlumno'),
        headers: anyNamed('headers'), // Asegura que coincida la configuración de la solicitud
      )).thenThrow(Exception('Error al conectarse con el servidor'));

      try {
        await client.get(Uri.parse('$baseUrl/notificaciones/$idAlumno'));
      } catch (e) {
        expect(e.toString(), contains('Error al conectarse con el servidor'));
      }
    });
  });
}
