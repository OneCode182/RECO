#!/bin/sh
#-----------------------------------------------------------
# Name: show_last_lines.sh
# Description: Displays the last 15 lines of three log files
#              in a POSIX-compatible way (no arrays).
#-----------------------------------------------------------

clear

# Space-separated list of log file paths
LOGS="/var/log/messages /var/log/syslog /var/log/auth.log"

echo "Displaying the last 15 lines of each log file:"
echo "----------------------------------------------------------"

# Loop over each log file in the list
for log in $LOGS
do
  if [ -f "$log" ]; then
    echo "File: $log"
    tail -n 15 "$log"
    echo "----------------------------------------------------------"
  else
    echo "File $log does not exist or is not readable."
    echo "----------------------------------------------------------"
  fi
done
