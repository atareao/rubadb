# 💾 `rubadb`: Backups Simples y Automatizados para tu Infraestructura Linux

[](https://atareao.es)
[](https://opensource.org/licenses/MIT)

## 🌟 ¿Qué es `rubadb`?

`rubadb` (Ruby Data Backup) es una herramienta ligera y eficiente diseñada para simplificar y automatizar las copias de seguridad de **aplicaciones autoalojadas** en entornos Linux y Docker.

Su principal objetivo es asegurar la consistencia de los datos críticos, orquestando el *dump* de bases de datos PostgreSQL, MySQL y la copia de los directorios de archivos adjuntos, para luego comprimirlos y organizarlos de forma segura.

**Ideal para hacer copias de seguridad de servicios como Immich, Nextcloud, o cualquier aplicación que dependa de una base de datos y un volumen de archivos.**

## ✨ Características Principales

  * **Orquestación de Backups:** Automatiza el flujo completo: BBDD → Archivos → Compresión → Almacenamiento.
  * **Soporte Multi-BBDD:** Diseñado para integrar *dumps* de PostgreSQL y MySQL (o cualquier otra BBDD a través de scripts externos).
  * **Gestión de Retención:** Limpia automáticamente las copias de seguridad antiguas para evitar el consumo excesivo de espacio en disco.
  * **Configuración por Entorno:** Se configura fácilmente mediante un único archivo de variables de entorno (o *yaml*) para una implementación rápida en Docker.
  * **Escrito en Shell Script:** Ligero, sin dependencias complejas y fácil de auditar.

## 🚀 Instalación y Uso

`rubadb` está pensado para ser ejecutado como una tarea programada (`cron`) o, preferiblemente, como un contenedor Docker.

### 1\. Requisitos

  * Un sistema Linux.
  * Docker y Docker Compose (recomendado para entornos *self-hosted*).

### 2\. Configuración (Ejemplo para Immich)

Necesitas un archivo de configuración para definir qué respaldar. Crea un archivo `config.env` (o similar):

```bash
# Configuración General
# Directorio donde se guardarán las copias de seguridad
BACKUP_DIR="/ruta/al/disco/backups/"
# Número de días para retener las copias (ej. 30 días)
RETENTION_DAYS=30
# Nombre base del servicio (ej. "immich")
SERVICE_NAME="immich"

# --------------------
# Base de Datos (PostgreSQL en el caso de Immich)
# --------------------
DB_TYPE="postgres"
# Usamos 'postgresus' para asegurar el dump consistente de la BBDD
DB_DUMP_COMMAND="/usr/local/bin/postgresus.sh"
# Opcionalmente, variables de conexión a la BBDD si rubadb lo necesita:
# PG_HOST=immich_postgres
# PG_USER=immich_user

# --------------------
# Archivos/Volúmenes
# --------------------
# Ruta del volumen de archivos de Immich (fotos/videos)
FILES_TO_BACKUP="/ruta/a/immich/library/"
```

### 3\. Ejecución del Backup

#### A) Desde Docker (Recomendado)

Ejecuta el contenedor de `rubadb` montando tu configuración y directorios:

```bash
docker run --rm \
    -v /ruta/a/config.env:/app/config.env \
    -v /ruta/al/disco/backups/:/backups \
    -v /ruta/a/immich/library:/app_data/library \
    atareao/rubadb:latest
```

#### B) En un Crontab de Linux

Si lo ejecutas directamente, asegúrate de que todas las variables de entorno están cargadas:

```bash
# 0 3 * * * /ruta/a/rubadb/run.sh --config /ruta/a/config.env
```

## 🧩 Integración con `postgresus`

`rubadb` está diseñado para funcionar perfectamente con herramientas especializadas como [`postgresus`](https://www.google.com/search?q=%5Bhttps://github.com/RostislavDugin/postgresus%5D\(https://github.com/RostislavDugin/postgresus\)) para asegurar que el *dump* de la base de datos sea atómico y consistente.

Simplemente define el *script* de `postgresus` como el `DB_DUMP_COMMAND` en tu configuración.

## 🤝 Contribución

¡`rubadb` es un proyecto de código abierto\! Las contribuciones, ya sean en forma de reportes de errores, sugerencias de características o Pull Requests, son bienvenidas.

Siéntete libre de abrir un *Issue* en GitHub para cualquier consulta.

## 📜 Licencia

Distribuido bajo la Licencia MIT. Consulta el archivo `LICENSE` para más información.

-----

[Ver otros proyectos de @atareao](https://atareao.es)
