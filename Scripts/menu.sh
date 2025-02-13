#!/bin/sh
# Menu Shell script using case statement with execution permission checks

# Function to display the menu options
show_menu() {
    echo "-----------------------------------------------------"
    echo "       Network Setup Script - Choose an option:      "
    echo "-----------------------------------------------------"
    echo "    1) Configure Home "
    echo "     |---- 1.1) Test PINGS"
    echo "   "
    echo "    2) Configure U  "
    echo "     |---- 2.1) Test PINGS"
    echo "                                                     "
    echo "    3) View Network Info"
    echo "                                                     "
    echo "    0)  Exit                                         "
    echo "-----------------------------------------------------"
}

# Function to give execution permission if needed and run the script
run_script() {
    script_name=$1
    if [ -f "$script_name" ]; then
        chmod +x "$script_name"  # Give execution permissions
        shift  # Remove the script name from the parameters list
        ./"$script_name" "$@"    # Run the script with the rest of the parameters
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
            # Data
            IP="192.168.1.7"
            NETMASK="255.255.255.0"
            DNS="192.168.1.1"
            GATEWAY="192.168.1.1"
            INTERFACE="wm0"

            run_script "autonet.sh" "$IP" "$NETMASK" "$DNS" "$GATEWAY" "$INTERFACE"
            ;;
        1.1)
            # Data
            IP="192.168.1.7"
            DNS="192.168.1.1"

            run_script "test_pings.sh" "$IP" "$DNS"  
            ;;
        2)
            # Data
            IP="10.2.77.114"
            NETMASK="255.255.0.0"
            DNS="10.2.65.1"
            GATEWAY="10.2.65.1"
            INTERFACE="wm0"

            # Execute
            run_script "autonet.sh" "$IP" "$NETMASK" "$DNS" "$GATEWAY" "$INTERFACE"
            ;;
        2.1)
            # Data
            IP="10.2.77.114"
            DNS="10.2.65.1"

            run_script "test_pings.sh" "$IP" "$DNS"  
            ;;
        3)
            run_script "net_info.sh"
            ;;
        0)
            break
            ;;

        *)
            clear
            echo "Invalid option. Please try again."
            ;;
    esac
done



    # Prompt the user to input the required parameters
    #read -p "Enter the word to search for: " word
    #read -p "Enter the path to the file: " path
    
    # Run point_3.sh with the parameters
    #echo "Running point_3.sh with parameters '$word' and '$path'..."
    #run_script "point_3.sh" "$word" "$path"
    #;;


