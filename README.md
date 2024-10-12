# edu_control_movile

## Descripción del Proyecto
Este proyecto consiste en el desarrollo de una aplicación móvil para la gestión de acceso y control estudiantil. Los alumnos podrán visualizar una credencial digital con sus datos, generar un código QR único para su identificación, y recibir notificaciones de la institución. Asimismo, los padres de familia tendrán acceso a un perfil detallado del alumno, historial de asistencias, horarios y notificaciones.

El sistema cuenta con autenticación segura para proteger la información personal y facilitar la comunicación eficiente entre la escuela, los alumnos y los padres.

## Objetivos del Proyecto
### Objetivo General
Desarrollar una aplicación móvil que permita a los alumnos y padres gestionar el acceso y visualizar información académica y personal, de manera segura y eficiente.

### Objetivos Específicos
1. Crear una **credencial digital** para los alumnos con su información personal y académica.
2. Implementar un **sistema de generación de códigos QR** únicos para cada alumno.
3. Desarrollar un **módulo de notificaciones** para la comunicación entre la institución y los usuarios.
4. Crear un **perfil del alumno** accesible para los padres con datos como matrícula, carrera y horarios.
5. Implementar un **sistema de registro de asistencias** accesible para los padres.
6. Asegurar la **protección de datos** mediante autenticación segura (OAuth2/JWT).
7. Facilitar la **comunicación entre la escuela, los alumnos y los padres** mediante un sistema de mensajería.

## Metodología de Trabajo
El desarrollo del proyecto sigue la metodología **Scrum**, trabajando en ciclos cortos (Sprints) y entregando incrementos funcionales al final de cada uno. Las revisiones se realizan cada dos semanas para asegurar el cumplimiento de los objetivos.

## Versionamiento y gestion de Ramas
Utilizaremos Versionamiento Semántico 2.0.0 para etiquetar las versiones del proyecto. Esto se hace siguiendo el formato MAJOR.MINOR.PATCH, donde:

MAJOR: Cambia cuando se realizan modificaciones incompatibles con versiones anteriores (cambios disruptivos en la API o funcionalidad).
MINOR: Cambia cuando se agregan nuevas funcionalidades de manera retrocompatible.
PATCH: Cambia cuando se realizan correcciones de errores o pequeños ajustes que no afectan la compatibilidad con versiones anteriores.

## Ramas:
-Rama principal (main o master).
-Ramas de desarrollo (develop).
-Ramas de características o feature branches.
-Estrategia de ramas para pruebas (hotfix, release).

## Estrategia de despliegue 
Estrategia de Despliegue Canary:
-Despliegue gradual
-Monitoreo y validación
-Roll-back (reversión)
-Despliegue completo

Para el proyecto de la aplicación móvil para alumnos y padres, el despliegue Canary permitirá probar nuevas características, como el módulo de credencial digital, el sistema de autenticación o el historial de asistencia, de manera controlada.

## Tecnologías a utilizar
-BackEnd: python (Flask)
-Base de Datos: MySQL
-FrontEnd: Flutter

## Instalación y Ejecución del Proyecto

### Clonar el Repositorio
Para clonar este repositorio, utiliza el siguiente comando en tu terminal:

```bash
git clone https://github.com/WasakaBe/EduControlMobile.git
cd EducontroMobile

## Instalar dependencias:
npm install

## Ejecutar el proyecto:
npm start