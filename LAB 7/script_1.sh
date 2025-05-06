#!/bin/sh

mostrar_menu() {
  echo "===== MENÚ DE INFORMACIÓN DE RED (NetBSD) ====="
  echo "1) Ver interfaces de red activas"
  echo "2) Mostrar la tabla de rutas"
  echo "3) Mostrar estadísticas de red"
  echo "4) Mostrar sockets abiertos y servicios"
  echo "5) Probar conectividad con ping"
  echo "6) Salir"
  echo "==============================================="
}

opcion=0

while [ "$opcion" -ne 6 ]; do
  mostrar_menu
  echo -n "Seleccione una opción (1-6): "
  read opcion

  case $opcion in
    1)
      echo "Interfaces de red activas:"
      ifconfig -a
      ;;
    2)
      echo "Tabla de rutas:"
      netstat -rn | more
      ;;
    3)
      echo "Estadísticas de red:"
      netstat -s | more
      ;;
    4)
      echo "Sockets abiertos y servicios:"
      sockstat | more
      ;;
    5)
      echo -n "Ingrese IP o dominio para hacer ping: "
      read destino
      ping -c 4 "$destino"
      ;;
    6)
      echo "Saliendo..."
      ;;
    *)
      echo "Opción no válida. Intente de nuevo."
      ;;
  esac

  echo ""
done


