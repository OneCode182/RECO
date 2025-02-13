#!/bin/sh

# Función para esperar a que el usuario presione Enter para continuar
esperar_tecla() {
    echo "Presione ENTER para continuar..."
    read dummy  # Espera la entrada del usuario
    exit 0
}

# Verifica si se proporciona la IP como argumento
if [ -z "$1" ]; then
    echo "Uso: $0 <IP>"
    exit 1
fi

# Definir valores fijos
DNS1="8.8.8.8"          # Servidor DNS primario
DNS2="1.1.1.1"          # Servidor DNS secundario

IP="$1"                 # IP proporcionada por el usuario
NETMASK="$2"            # Máscara de red
DNS="$3"                # Servidor DNS primario
GATEWAY="$4"            # Puerta de enlace
INTERFACE="$5"          # Cambia esto según tu interfaz (ejemplo: re0, rtk0, etc.)

# Configurar la IP y máscara de red
echo "Configurando la IP $IP en la interfaz $INTERFAZ..."
echo "inet $IP netmask $NETMASK" > /etc/ifconfig.$INTERFAZ

# Configurar la puerta de enlace
echo "Estableciendo gateway predeterminado: $GATEWAY..."

# Crear una copia de seguridad antes de modificar el archivo
cp /etc/rc.conf /etc/rc.conf.bak

# Eliminar todas las líneas que contienen "defaultroute="
sed -i '/^defaultroute=/d' /etc/rc.conf

# Agregar la nueva entrada de gateway
echo "defaultroute=\"$GATEWAY\"" >> /etc/rc.conf
route add default $GATEWAY

# Configurar el DNS sin sobrescribir
echo "Configurando servidores DNS..."

# Eliminar cualquier línea duplicada antes de añadir nuevos DNS
sed -i "/^nameserver $DNS/d" /etc/resolv.conf
sed -i "/^nameserver $DNS1/d" /etc/resolv.conf
sed -i "/^nameserver $DNS2/d" /etc/resolv.conf

# Agregar los nuevos servidores DNS
echo "nameserver $DNS"  >> /etc/resolv.conf
echo "nameserver $DNS1" >> /etc/resolv.conf
echo "nameserver $DNS2" >> /etc/resolv.conf


# Reiniciar la red para aplicar los cambios
echo "Reiniciando el servicio de red..."
sh /etc/rc.d/network restart

echo "Configuración de red aplicada exitosamente."

# Wait ENTER
esperar_tecla