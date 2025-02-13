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