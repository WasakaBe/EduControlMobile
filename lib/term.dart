import 'package:flutter/material.dart';

class TermScreen extends StatelessWidget {
  const TermScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos de Servicio'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Términos y Condiciones de Uso de EDU CONTROL',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Fecha de última actualización: 15 de noviembre de 2024',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Text(
              '1. Definiciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Institución: Se refiere al Centro Bachillerato Tecnológico Agropecuario No. 5 (CBTA5).\n'
              'Sitio: Se refiere a la plataforma web y aplicación móvil EDU CONTROL, diseñadas para gestionar información académica de la institución.\n'
              'Usuarios: Incluye a los alumnos, padres o tutores de los alumnos, y docentes que pertenecen a la institución.\n'
              'Administrador: Persona encargada de la gestión completa del sitio web, responsable de la administración de datos y servicios.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2. Servicios Ofrecidos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'EDU CONTROL proporciona las siguientes funcionalidades:\n\n'
              'Para Padres de Familia: Visualización de datos del alumnado, incluyendo información personal, materias de clase, asistencias y calificaciones. Comunicación directa con docentes y el administrador, y notificaciones sobre actividades importantes.\n'
              'Para Alumnos: Visualización de horarios, asistencias, credencial escolar virtual, envío de mensajes al administrador, acceso a materiales de estudio y recursos de aprendizaje, y consultar el estado de su progreso académico.\n'
              'Para Docentes: Gestión de horarios, adición de alumnos a clases, toma de asistencias, subir recursos de aprendizaje, y comunicación con alumnos y padres de familia.\n'
              'Para el Administrador: Control total sobre la creación, actualización, visualización y eliminación de credenciales escolares, horarios escolares, gestión de datos de alumnos y docentes, y recibir y gestionar mensajes enviados por los usuarios.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3. Uso del Sitio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Acceso: El sitio está destinado exclusivamente a los miembros de la institución (alumnos, padres o tutores de alumnos, y docentes). El acceso está restringido para cualquier persona ajena a la institución, y está protegido mediante credenciales de acceso asignadas individualmente.\n\n'
              'Credenciales de Acceso: Los usuarios deben mantener la confidencialidad de sus credenciales de acceso y notificar de inmediato al administrador en caso de pérdida o sospecha de uso no autorizado. El mal uso de las credenciales puede resultar en la suspensión temporal o permanente de la cuenta.\n\n'
              'Mensajes al Administrador: Los usuarios pueden enviar mensajes al administrador para reportar problemas relacionados con credenciales escolares, asistencia, horarios u otras inquietudes académicas.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '4. Restricciones de Uso',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Prohibiciones: Queda prohibido el uso del sitio para cualquier propósito ilegal o no autorizado. Los usuarios no deben intentar obtener acceso no autorizado a otras cuentas, sistemas informáticos o redes conectadas al sitio. No se permite alterar, modificar, realizar ingeniería inversa o descompilar el código fuente del sitio.\n\n'
              'Contenido del Usuario: El usuario se compromete a no enviar contenido ofensivo, inapropiado o ilegal a través de las funciones de mensajería del sitio. El contenido enviado debe respetar la integridad y dignidad de los demás usuarios.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '5. Responsabilidades del Administrador',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'El administrador es responsable de:\n\n'
              'Gestión de Credenciales: Creación, actualización, visualización y eliminación de credenciales escolares, garantizando que los datos personales se mantengan seguros.\n\n'
              'Gestión de Horarios: Creación, actualización, visualización y eliminación de horarios escolares, asegurando la disponibilidad y claridad de la información para estudiantes y docentes.\n\n'
              'Gestión de Datos: Visualización y gestión de la información de alumnos, docentes, becas, y otros datos académicos relevantes.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '6. Limitaciones de Responsabilidad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'EDU CONTROL no se hace responsable de:\n\n'
              'Errores Técnicos: Interrupciones del servicio, pérdida de datos o cualquier otro problema técnico que pueda ocurrir, incluyendo problemas derivados del mantenimiento de la plataforma o de fallas en sistemas externos.\n\n'
              'Contenido de Terceros: Información inexacta o contenido proporcionado por los usuarios del sitio. Los usuarios son responsables de la precisión de los datos que ingresen.\n\n'
              'Uso Indebido: Cualquier daño resultante del uso indebido de la plataforma por parte de los usuarios, como intentos de hackeo o actividades fraudulentas.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '7. Privacidad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'La privacidad de nuestros usuarios es una prioridad. Toda la información personal recopilada a través del sitio se maneja de acuerdo con nuestra Política de Privacidad. Los datos personales se utilizan únicamente para los fines para los que fueron recopilados y no se comparten sin consentimiento.\n\n'
              'Recopilación de Datos: Se recopilan datos como nombre, fecha de nacimiento, correo electrónico, asistencias y calificaciones, con el propósito de mejorar la experiencia académica y asegurar el buen funcionamiento de la institución.\n\n'
              'Consentimiento del Usuario: Al utilizar la plataforma, los usuarios consienten el uso de sus datos para los fines aquí descritos.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '8. Modificaciones a los Términos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Nos reservamos el derecho de modificar estos términos en cualquier momento. Las modificaciones serán efectivas inmediatamente después de su publicación en el sitio. Es responsabilidad del usuario revisar periódicamente estos términos para estar al tanto de cualquier cambio.\n\n'
              'Notificaciones de Cambios: Los usuarios recibirán notificaciones sobre cambios importantes en los términos y condiciones, por correo electrónico o mediante notificaciones en la plataforma.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '9. Cancelación y Suspensión de Cuenta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Suspensión de Cuenta: El administrador se reserva el derecho de suspender la cuenta de cualquier usuario que incumpla los términos de uso. La suspensión puede ser resultado de intentos de violación de seguridad, acoso, o cualquier actividad perjudicial.\n\n'
              'Eliminación de Cuenta: Los usuarios pueden solicitar la eliminación de su cuenta, sin embargo, algunos registros serán conservados según los requerimientos institucionales.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '10. Contacto',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Para cualquier consulta o problema relacionado con el uso del sitio, por favor contacte al administrador a través de la función de mensajería del sitio o en el correo electrónico: educontroladmin@gmail.com.\n\n'
              'Centro Bachillerato Tecnológico Agropecuario No. 5 (CBTA5)\n'
              'Dirección: Adolfo López Mateos SN, Aviación Civil, 43000 Huejutla, Hgo.\n'
              'Teléfono: 789 896 0065\n'
              'Horario de Atención: Lunes a Viernes de 9:00 AM a 5:00 PM',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
