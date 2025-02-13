#!/bin/sh

# Function to wait for user input before continuing
wait_for_keypress() {
    echo "Press ENTER to continue..."
    read dummy
}

# Define the output file
OUTPUT_FILE="network_report.txt"

# Clear previous content of the file
echo "Generating network report..." > "$OUTPUT_FILE"
echo "=====================================" | tee -a "$OUTPUT_FILE"
echo "  Network Card Information " | tee -a "$OUTPUT_FILE"
echo "=====================================" | tee -a "$OUTPUT_FILE"
echo "" | tee -a "$OUTPUT_FILE"

# Get all available network interfaces
INTERFACES=$(ifconfig -l)

for INTERFACE in $INTERFACES; do
    echo "-------------------------------------" | tee -a "$OUTPUT_FILE"
    echo " Interface: $INTERFACE" | tee -a "$OUTPUT_FILE"
    echo "-------------------------------------" | tee -a "$OUTPUT_FILE"

    # Get manufacturer and model (if available in NetBSD)
    MANUFACTURER=$(dmesg | grep "$INTERFACE" | head -n 1)
    echo " Manufacturer & Model: ${MANUFACTURER:-Unknown}" | tee -a "$OUTPUT_FILE"

    # Get MAC address
    MAC=$(ifconfig "$INTERFACE" | awk '/ether/ {print $2}')
    echo " MAC Address: ${MAC:-Not available}" | tee -a "$OUTPUT_FILE"

    # Get IPv4 address
    IPV4=$(ifconfig "$INTERFACE" | awk '/inet / {print $2}')
    echo " IPv4 Address: ${IPV4:-Not available}" | tee -a "$OUTPUT_FILE"

    # Get IPv6 address
    IPV6=$(ifconfig "$INTERFACE" | awk '/inet6 / {print $2}')
    echo " IPv6 Address: ${IPV6:-Not available}" | tee -a "$OUTPUT_FILE"

    # Get connection speed (only for active interfaces)
    SPEED=$(ifconfig "$INTERFACE" | grep "media" | awk '{print $2, $3}')
    echo " Connection Speed: ${SPEED:-Unknown}" | tee -a "$OUTPUT_FILE"

    # Get SSID if the interface is wireless
    if ifconfig "$INTERFACE" | grep -q "ssid"; then
        SSID=$(ifconfig "$INTERFACE" | awk '/ssid/ {print $2}')
        echo " SSID: ${SSID:-Unknown}" | tee -a "$OUTPUT_FILE"
    fi

    # Get transmitted and received bytes
    TX_BYTES=$(netstat -I "$INTERFACE" | awk 'NR==2 {print $7}')
    RX_BYTES=$(netstat -I "$INTERFACE" | awk 'NR==2 {print $10}')
    echo " Transmitted Bytes: ${TX_BYTES:-0} bytes" | tee -a "$OUTPUT_FILE"
    echo " Received Bytes: ${RX_BYTES:-0} bytes" | tee -a "$OUTPUT_FILE"

    echo "" | tee -a "$OUTPUT_FILE"  # Space to separate interfaces
done

echo "=====================================" | tee -a "$OUTPUT_FILE"
echo "   End of Report " | tee -a "$OUTPUT_FILE"
echo "=====================================" | tee -a "$OUTPUT_FILE"

# Notify the user where the report is saved
echo "Network report saved to: $OUTPUT_FILE"

# Wait for user input before exiting
wait_for_keypress
