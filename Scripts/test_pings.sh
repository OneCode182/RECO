# Función para esperar a que el usuario presione Enter para continuar
esperar_tecla() {
    echo "Presione ENTER para continuar..."
    read dummy  # Espera la entrada del usuario
    exit 0
}

# Data
IP="$1"
DNS="$2"

# Ping Red Local
echo "PINGS RED LOCAL (IP)"
ping -c 3 "$IP"

# Ping DNS y Gateway
echo "PINGS DNS y Gateway"
ping -c 3 "$DNS"

# Ping Internet
echo "PINGS Acceso a Internet"
ping -c 3 "google.com"


# ENTER
esperar_tecla