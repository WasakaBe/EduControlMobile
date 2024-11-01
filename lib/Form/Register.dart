import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Importa dart:io para obtener la IP

import 'package:movil_educontrol/Api/api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0; // Controlar la sección actual

  // Controladores para cada campo del formulario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPController = TextEditingController();
  final TextEditingController _apellidoMController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _respuestaPreguntaController =
      TextEditingController();

  bool _isLoading = false;
  String? _ipAddress;
  int? _selectedSexo; // Variable para almacenar el sexo seleccionado
  int? _selectedPregunta; // Variable para almacenar la pregunta seleccionada
  List<dynamic> _sexos =
      []; // Lista para almacenar los sexos obtenidos de la API
  List<dynamic> _preguntas =
      []; // Lista para almacenar las preguntas obtenidas de la API

  // Variables para control de borde rojo
  bool _nombreValido = true;
  bool _apellidoPValido = true;
  bool _apellidoMValido = true;

  // Expresión regular para validar solo caracteres de texto (mayúsculas, minúsculas, acentos, y espacios)
  final RegExp _textRegExp = RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúñÑ\s]+$");

  // Función para generar token aleatorio
  String generateToken() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const numbers = '0123456789';

    String getRandomChar(String source) {
      final randomIndex = DateTime.now().millisecondsSinceEpoch % source.length;
      return source[randomIndex];
    }

    // Genera un token de 7 caracteres
    return getRandomChar(letters) +
        getRandomChar(letters) +
        getRandomChar(letters) +
        getRandomChar(numbers) +
        getRandomChar(numbers) +
        getRandomChar(numbers) +
        getRandomChar(numbers);
  }

  // Obtener la IP del dispositivo
  Future<void> _getIPAddress() async {
    try {
      final List<InternetAddress> addresses =
          await InternetAddress.lookup('google.com');
      if (addresses.isNotEmpty) {
        setState(() {
          _ipAddress = addresses.first.address;
        });
      }
    } catch (e) {
      setState(() {
        _ipAddress = 'Desconocida'; // En caso de error
      });
    }
  }

  // Obtener la lista de sexos desde la API
  Future<void> _getSexos() async {
    final response = await http.get(Uri.parse('$baseUrl/sexo'));
    if (response.statusCode == 200) {
      setState(() {
        _sexos = jsonDecode(response.body);
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener la lista de sexos')),
      );
    }
  }

  // Obtener la lista de preguntas desde la API
  Future<void> _getPreguntas() async {
    final response = await http.get(Uri.parse('$baseUrl/pregunta'));
    if (response.statusCode == 200) {
      setState(() {
        _preguntas = jsonDecode(response.body);
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error al obtener la lista de preguntas secretas')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getIPAddress(); // Obtener la IP al inicializar la pantalla
    _getSexos(); // Obtener la lista de sexos al inicializar la pantalla
    _getPreguntas(); // Obtener la lista de preguntas al inicializar la pantalla
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() ||
        _selectedSexo == null ||
        _selectedPregunta == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Genera el token de usuario
    final tokenUsuario = generateToken();

    final url = Uri.parse('$baseUrl/users/insert');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'nombre_usuario': _nombreController.text,
      'app_usuario': _apellidoPController.text,
      'apm_usuario': _apellidoMController.text,
      'fecha_nacimiento_usuario': _fechaNacimientoController.text,
      'token_usuario': tokenUsuario, // Usa el token generado
      'correo_usuario': _correoController.text,
      'pwd_usuario': _passwordController.text,
      'phone_usuario': _telefonoController.text,
      'idRol': 4, // Asignar un rol predeterminado, por ejemplo, estudiante
      'idSexo': _selectedSexo, // Enviar el sexo seleccionado
      'idPregunta': _selectedPregunta, // Enviar la pregunta seleccionada
      'ip_usuario': _ipAddress ??
          'Desconocida', // Usar la IP obtenida o 'Desconocida' si no se puede obtener
      'idCuentaActivo': 1, // Asignar valor predeterminado
      'respuestaPregunta': _respuestaPreguntaController.text,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado exitosamente')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context); // Regresar a la pantalla anterior
      } else {
        final data = jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data['error'] ?? 'Error al registrar el usuario')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en la solicitud: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Widget _buildSection1() {
    return Column(
      children: [
        TextFormField(
          controller: _nombreController,
          decoration: InputDecoration(
            labelText: 'Nombre',
            border: const OutlineInputBorder(),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: _nombreValido
                      ? Colors.green
                      : Colors.red), // Bordes dinámicos
            ),
          ),
          onChanged: (value) {
            setState(() {
              _nombreValido = _textRegExp.hasMatch(value);
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            if (!_textRegExp.hasMatch(value)) {
              return 'Solo se permiten letras, espacios y acentos';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _apellidoPController,
          decoration: InputDecoration(
            labelText: 'Apellido Paterno',
            border: const OutlineInputBorder(),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: _apellidoPValido
                      ? Colors.green
                      : Colors.red), // Bordes dinámicos
            ),
          ),
          onChanged: (value) {
            setState(() {
              _apellidoPValido = _textRegExp.hasMatch(value);
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            if (!_textRegExp.hasMatch(value)) {
              return 'Solo se permiten letras, espacios y acentos';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _apellidoMController,
          decoration: InputDecoration(
            labelText: 'Apellido Materno',
            border: const OutlineInputBorder(),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: _apellidoMValido
                      ? Colors.green
                      : Colors.red), // Bordes dinámicos
            ),
          ),
          onChanged: (value) {
            setState(() {
              _apellidoMValido = value.isEmpty || _textRegExp.hasMatch(value);
            });
          },
          validator: (value) {
            if (value != null &&
                value.isNotEmpty &&
                !_textRegExp.hasMatch(value)) {
              return 'Solo se permiten letras, espacios y acentos';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _fechaNacimientoController,
          decoration: const InputDecoration(
            labelText: 'Fecha de Nacimiento (YYYY-MM-DD)',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSection2() {
    return Column(
      children: [
        TextFormField(
          controller: _correoController,
          decoration: const InputDecoration(
            labelText: 'Correo Electrónico',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es requerido';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _telefonoController,
          decoration: const InputDecoration(
            labelText: 'Teléfono',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildSection3() {
    return Column(
      children: [
        // Campo de selección para el sexo
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Sexo'),
          value: _selectedSexo,
          items: _sexos.map<DropdownMenuItem<int>>((sexo) {
            return DropdownMenuItem<int>(
              value: sexo['id_sexos'],
              child: Text(sexo['nombre_sexo']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSexo = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Por favor, seleccione un sexo';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        // Campo de selección para la pregunta
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Pregunta Secreta'),
          value: _selectedPregunta,
          items: _preguntas.map<DropdownMenuItem<int>>((pregunta) {
            return DropdownMenuItem<int>(
              value: pregunta['id_preguntas'],
              child: Text(pregunta['nombre_preguntas']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPregunta = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Por favor, seleccione una pregunta';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _respuestaPreguntaController,
          decoration: const InputDecoration(
              labelText: 'Respuesta a la Pregunta de Seguridad'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _currentStep,
                  children: [
                    _buildSection1(),
                    _buildSection2(),
                    _buildSection3(),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(
                      onPressed: _previousStep,
                      child: const Text('Anterior'),
                    ),
                  if (_currentStep < 2)
                    ElevatedButton(
                      onPressed: _nextStep,
                      child: const Text('Siguiente'),
                    ),
                  if (_currentStep == 2 && !_isLoading)
                    ElevatedButton(
                      onPressed: _register,
                      child: const Text('Registrar'),
                    ),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
