#!/bin/sh
#-----------------------------------------------------------
# Name: log_menu.sh
# Description: Menu to review log files by either showing the
#              last 15 lines or filtering those lines by a keyword.
#-----------------------------------------------------------

# Function to display the menu options
show_menu() {
    echo "-----------------------------------------------------"
    echo "      Log File Review Menu - Choose an option:       "
    echo "-----------------------------------------------------"
    echo "   1) Show the last 15 lines of log files"
    echo "   2) Filter the last 15 lines by a keyword"

    echo "   0) Exit"
    echo "-----------------------------------------------------"
}

# Function to give execution permission if needed and run the script
run_script() {
    script_name=$1
    if [ -f "$script_name" ]; then
        chmod +x "$script_name"
        shift  # Remove the script name from the parameters list
        ./"$script_name" "$@"
    else
        echo "Error: $script_name not found."
    fi
}

while true; do
    show_menu
    # Read user choice
    read -p "Enter your choice: " choice
    echo "Running Script..."
    
    case $choice in
        1)
            run_script "1show_last_lines.sh"
            ;;
        2)
            run_script "2filter_logs.sh"
            ;;
        0)
            echo "Exiting..."
            exit 0
            ;;
        *)
            clear
            echo "Invalid option. Please try again."
            ;;
    esac
    
    echo ""
    read -p "Press ENTER to return to the menu..."
    clear
done
