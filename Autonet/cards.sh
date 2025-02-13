#!/bin/sh

# Function to wait for user input before continuing
wait_for_keypress() {
    echo "Press ENTER to continue..."
    read dummy
}

# Get all available network interfaces
INTERFACES=$(ifconfig -l)

echo "====================================="
echo "       Network Card Information "
echo "====================================="
echo ""

for INTERFACE in $INTERFACES; do
    echo "-------------------------------------"
    echo "      Interface: $INTERFACE"
    echo "-------------------------------------"

    # Get manufacturer and model (if available in NetBSD)
    MANUFACTURER=$(dmesg | grep "$INTERFACE" | head -n 1)
    echo "Manufacturer & Model: ${MANUFACTURER:-Unknown}"

    # Get MAC address
    MAC=$(ifconfig "$INTERFACE" | awk '/ether/ {print $2}')
    echo "MAC Address: ${MAC:-Not available}"

    # Get IPv4 address
    IPV4=$(ifconfig "$INTERFACE" | awk '/inet / {print $2}')
    echo "IPv4 Address: ${IPV4:-Not available}"

    # Get IPv6 address
    IPV6=$(ifconfig "$INTERFACE" | awk '/inet6 / {print $2}')
    echo "IPv6 Address: ${IPV6:-Not available}"

    # Get connection speed (only for active interfaces)
    SPEED=$(ifconfig "$INTERFACE" | grep "media" | awk '{print $2, $3}')
    echo "Connection Speed: ${SPEED:-Unknown}"

    # Get SSID if the interface is wireless
    if ifconfig "$INTERFACE" | grep -q "ssid"; then
        SSID=$(ifconfig "$INTERFACE" | awk '/ssid/ {print $2}')
        echo "SSID: ${SSID:-Unknown}"
    fi

    # Get transmitted and received bytes
    TX_BYTES=$(netstat -I "$INTERFACE" | awk 'NR==2 {print $7}')
    RX_BYTES=$(netstat -I "$INTERFACE" | awk 'NR==2 {print $10}')
    echo "Transmitted Bytes: ${TX_BYTES:-0} bytes"
    echo "Received Bytes: ${RX_BYTES:-0} bytes"

    echo ""  # Space to separate interfaces
done

echo "====================================="
echo " 🔍 End of Report "
echo "====================================="

# Wait for user input before exiting
wait_for_keypress
