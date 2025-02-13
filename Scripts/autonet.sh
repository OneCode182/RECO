#!/bin/sh

# Verifica si se proporciona la IP como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 <IP>"
    exit 1
fi

# Definir valores fijos
INTERFAZ="wm0"          # Cambia esto según tu interfaz (ejemplo: re0, rtk0, etc.)
NETMASK="255.255.255.0" # Máscara de red
GATEWAY="192.168.1.1"   # Puerta de enlace
DNS1="8.8.8.8"          # Servidor DNS primario
DNS2="1.1.1.1"          # Servidor DNS secundario
IP="$1"                 # IP proporcionada por el usuario

# Configurar la IP y máscara de red
echo "Configurando la IP $IP en la interfaz $INTERFAZ..."
echo "inet $IP netmask $NETMASK" > /etc/ifconfig.$INTERFAZ

# Configurar la puerta de enlace
echo "Estableciendo gateway predeterminado: $GATEWAY..."
echo "defaultroute=\"$GATEWAY\"" >> /etc/rc.conf
route add default $GATEWAY

# Configurar el DNS
echo "Configurando servidores DNS..."
cat > /etc/resolv.conf <<EOF
nameserver $DNS1
nameserver $DNS2
EOF

# Reiniciar la red para aplicar los cambios
echo "Reiniciando el servicio de red..."
sh /etc/rc.d/network restart

echo "Configuración de red aplicada exitosamente."
exit 0