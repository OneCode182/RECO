#!/bin/sh
#
# Script to copy DNS configuration files for NetBSD
#

# Ensure the source files exist in the current directory
for file in named.conf named.ca silva.com.it.hosts; do
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' not found in the current directory."
        exit 1
    fi
done

# Create /etc/DNS directory if it doesn't exist
if [ ! -d /etc/DNS ]; then
    mkdir -p /etc/DNS || {
        echo "Error: Unable to create /etc/DNS directory."
        exit 1
    }
fi

# Copy the files to the designated locations
cp named.conf /etc/ || { echo "Error copying named.conf"; exit 1; }
cp named.ca /etc/ || { echo "Error copying named.ca"; exit 1; }
cp silva.com.it.hosts /etc/DNS/ || { echo "Error copying silva.com.it.hosts"; exit 1; }

echo "All files copied successfully."
exit 0