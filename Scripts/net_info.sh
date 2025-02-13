#!/bin/sh

# Función para esperar a que el usuario presione Enter o cualquier tecla para continuar
esperar_tecla() {
    echo "Presione ENTER o cualquier tecla para continuar..."
    while true; do
        read -r -n 1 key  # Lee un solo carácter sin necesidad de presionar Enter
        if [ -n "$key" ]; then
            break  # Sale del bucle cuando se detecta una tecla
        fi
    done
    exit 0
}

# Obtener la interfaz de red activa
INTERFAZ=$(route -n get default 2>/dev/null | awk '/interface:/ {print $2}')

# Obtener la dirección IP
IP=$(ifconfig "$INTERFAZ" | awk '/inet / {print $2}')

# Obtener la máscara de red
NETMASK=$(ifconfig "$INTERFAZ" | awk '/inet / {print $4}')

# Obtener la puerta de enlace (gateway)
GATEWAY=$(route -n get default 2>/dev/null | awk '/gateway:/ {print $2}')

# Obtener los servidores DNS
DNS=$(awk '/nameserver/ {print $2}' /etc/resolv.conf | paste -sd ", ")

# Mostrar la información de red
echo "Información de red:"
echo "-------------------"
echo "IP:       $IP"
echo "Netmask:  $NETMASK"
echo "DNS:      $DNS"
echo "Gateway:  $GATEWAY"

# EXIT
esperar_tecla