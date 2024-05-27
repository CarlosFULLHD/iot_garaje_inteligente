# SmartPark - Documentación

![SmartPark Logo](link_to_logo_image)

Este repositorio contiene el código fuente y la documentación para el proyecto SmartPark, una aplicación de gestión de estacionamiento inteligente.

---

## Configuración de la Base de Datos

Para ejecutar la base de datos en un contenedor Docker, utiliza el siguiente comando:

```bash
docker run -d --name smartpark_c -e POSTGRES_PASSWORD=12345 -e POSTGRES_USER=admin -e POSTGRES_DB=smartpark_db -p 5432:5432 postgres:15.3


Versiones Utilizadas
Flutter: 3.19.6
PostgreSQL: 15.3
Java SDK: 20
Estructura del Frontend
La arquitectura Provider en Flutter es una manera eficiente de gestionar el estado y la inyección de dependencias en una aplicación. Aquí está cómo se organiza la estructura del proyecto:

Config: Configuración de Rutas.

Ejemplo: routes.dart
Models: Modelos de datos.

Ejemplo: user_model.dart
Providers: Gestión del estado.

Ejemplo: user_provider.dart
Styles: Definición de estilos.

Ejemplo: theme.dart
Services: Servicios de la aplicación.

Ejemplo: api_service.dart
Utils: Utilidades y constantes globales.

Ejemplo: constants.dart
Views: Vistas de la aplicación.

Ejemplo: home_screen.dart
Widgets: Componentes reutilizables.

Ejemplo: custom_button.dart
Estructura del Backend
La estructura del backend sigue los principios de una arquitectura limpia y escalable:

Entity: Representación de los objetos del mundo real.

Ejemplo: UserEntity.java
Repository: Abstracción del acceso a los datos.

Ejemplo: UserRepository.java
Controller: Gestión de solicitudes HTTP.

Ejemplo: UserController.java
DTO: Transferencia de datos entre capas.

Ejemplo: UserDTO.java
BL: Lógica de negocio de la aplicación.

Ejemplo: OrderLogic.java
BD: Sistema de almacenamiento principal.

Ejemplo: MySQLDatabase.java
Services: Componentes con funcionalidades específicas.

Ejemplo: AuthService.java
