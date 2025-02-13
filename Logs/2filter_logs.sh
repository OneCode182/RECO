#!/bin/bash
#-----------------------------------------------------------
# Name: filter_logs.sh
# Description: Filters the last 15 lines of three log files to 
#              display only lines containing a specific keyword.
# Author: [Your Name]
# Date: [Creation Date]
#-----------------------------------------------------------

# Clear the screen
clear

# Prompt the user for the keyword to search for.
read -p "Enter the keyword to search in the logs: " keyword

# Exit if no keyword is provided.
if [ -z "$keyword" ]; then
  echo "No keyword entered. Exiting..."
  exit 1
fi

# Define an array with the paths of the log files.
# Modify these paths as needed for your system.
logs=(
  "/var/log/messages"
  "/var/log/syslog"
  "/var/log/auth.log"
)

echo "Displaying the last 15 lines of each log file containing '$keyword':"
echo "----------------------------------------------------------------------------------"

# Loop through each log file, display its last 15 lines, and filter with grep.
for log in "${logs[@]}"; do
  if [ -f "$log" ]; then
    echo "File: $log"
    tail -n 15 "$log" | grep -i --color=auto "$keyword"
    echo "----------------------------------------------------------------------------------"
  else
    echo "File $log does not exist or is not readable."
    echo "----------------------------------------------------------------------------------"
  fi
done
