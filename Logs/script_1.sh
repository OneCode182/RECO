#!/bin/bash
#-----------------------------------------------------------
# Nombre: script_1.sh
# Descripción: Muestra las últimas 15 líneas de 3 archivos de log
#              con información general de actividad del sistema.
# Autor: [Tu Nombre]
# Fecha: [Fecha de creación]
#-----------------------------------------------------------

# Limpiar la pantalla
clear

# Definir un arreglo con las rutas de los archivos de log.
# Modifica estas rutas según tu distribución o sistema operativo.
logs=(
  "/var/log/messages"
  "/var/log/syslog"
  "/var/log/auth.log"
)

echo "Mostrando las últimas 15 líneas de cada archivo de log:"
echo "----------------------------------------------------------"

# Recorrer cada archivo de log y mostrar sus últimas 15 líneas.
for log in "${logs[@]}"; do
  if [ -f "$log" ]; then
    echo "Archivo: $log"
    tail -n 15 "$log"
    echo "----------------------------------------------------------"
  else
    echo "El archivo $log no existe o no se puede leer."
    echo "----------------------------------------------------------"
  fi
done

# Fin del script.