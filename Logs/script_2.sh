#!/bin/bash
#-----------------------------------------------------------
# Nombre: script_2.sh
# Descripción: Muestra las últimas 15 líneas de 3 archivos de log y
#              filtra dichas líneas para mostrar solo las que
#              contienen una palabra específica.
# Autor: [Tu Nombre]
# Fecha: [Fecha de creación]
#-----------------------------------------------------------

# Limpiar la pantalla
clear

# Solicitar al usuario la palabra clave a buscar
read -p "Introduce la palabra a buscar en los logs: " palabra

# Comprobar que se ha introducido una palabra
if [ -z "$palabra" ]; then
  echo "No se ha introducido ninguna palabra. Saliendo..."
  exit 1
fi

# Definir un arreglo con las rutas de los archivos de log.
# Modifica estas rutas según tu distribución o sistema operativo.
logs=(
  "/var/log/messages"
  "/var/log/syslog"
  "/var/log/auth.log"
)

echo "Mostrando las últimas 15 líneas de cada archivo de log que contienen '$palabra':"
echo "----------------------------------------------------------------------------------"

# Recorrer cada archivo de log, obtener las últimas 15 líneas y filtrar con grep.
for log in "${logs[@]}"; do
  if [ -f "$log" ]; then
    echo "Archivo: $log"
    tail -n 15 "$log" | grep -i --color=auto "$palabra"
    echo "----------------------------------------------------------------------------------"
  else
    echo "El archivo $log no existe o no se puede leer."
    echo "----------------------------------------------------------------------------------"
  fi
done

# Fin del script.