# Calculadora de Notas

Esta es una aplicación web sencilla para calcular la nota final de un semestre, implementada en PHP, con almacenamiento en PostgreSQL y desplegada sobre Apache en un servidor Ubuntu.

---

## Descripción

La aplicación permite:

- Ingresar el nombre del estudiante y las tres notas parciales (cada una correspondiente a un tercio del semestre).
- Calcular la nota final con ponderaciones: 30% para la primera y segunda nota, y 40% para la tercera.
- Guardar los registros en una base de datos PostgreSQL.
- Visualizar todos los registros almacenados en un modal desde la misma interfaz.

---

## Tecnologías usadas

- Ubuntu Server 24.04 LTS
- Apache 2
- PHP 8.x (con PDO y extensión pgsql)
- PostgreSQL 16.x
- HTML, CSS (con hoja de estilos minimalista y moderna)

---

## Estructura de archivos

- `/var/www/html/notas/` - Directorio raíz del proyecto web.
- `index.php` - Página principal con formulario, lógica PHP y visualización.
- `config.php` - Configuración y conexión PDO a PostgreSQL.
- `styles.css` - Hoja de estilos CSS para diseño minimalista y responsivo.

---

## Configuración y despliegue

1. **Instalar Apache, PHP y PostgreSQL** en Ubuntu.
2. **Configurar PostgreSQL:**
   - Crear base de datos `notas_db` (o como se prefiera).
   - Crear usuario con permisos sobre la tabla `notas`.
   - Crear tabla `notas` con columnas: id (serial), nombre, nota1, nota2, nota3, nota_final y fecha.
3. **Configurar conexión en `config.php`** con las credenciales correctas.
4. **Subir los archivos al servidor** dentro de `/var/www/html/notas/`.
5. **Acceder vía navegador** a la IP o dominio del servidor para usar la aplicación.

---

## Uso

- Rellenar el formulario con nombre y notas.
- Hacer clic en "Calcular y Guardar" para almacenar el registro.
- Clic en "Ver todas las notas" para abrir un modal con todos los registros guardados.

---

## GitHub y control de versiones

- El proyecto está versionado con Git.
- Para subir cambios se recomienda usar autenticación mediante token personal o SSH.
- Configurar Git en el servidor con usuario y correo para asociar correctamente los commits.

---

## Autor

[Tu Nombre] — [tu_email@example.com]

---

## Licencia

Este proyecto está bajo licencia MIT. Consulta el archivo LICENSE para más detalles.
