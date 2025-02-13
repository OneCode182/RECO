#!/bin/bash
#-----------------------------------------------------------
# Name: show_last_lines.sh
# Description: Displays the last 15 lines of three log files
#              containing general system activity data.
# Author: [Your Name]
# Date: [Creation Date]
#-----------------------------------------------------------

# Clear the screen
clear

# Define an array with the paths of the log files.
# Modify these paths as needed for your system.
logs=(
  "/var/log/messages"
  "/var/log/syslog"
  "/var/log/auth.log"
)

echo "Displaying the last 15 lines of each log file:"
echo "----------------------------------------------------------"

# Loop through each log file and display its last 15 lines.
for log in "${logs[@]}"; do
  if [ -f "$log" ]; then
    echo "File: $log"
    tail -n 15 "$log"
    echo "----------------------------------------------------------"
  else
    echo "File $log does not exist or is not readable."
    echo "----------------------------------------------------------"
  fi
done