#!/bin/sh
# Menu Shell script using case statement with execution permission checks

# Function to display the menu options
show_menu() {
    echo "-----------------------------------------------------"
    echo "        Shell Scripts Menu - Choose an option:"
    echo "-----------------------------------------------------"
    echo "  'ls' Command Filters                            "
    echo "    1) Most Recent              (1most_recent.sh)"
    echo "    2) Oldest                   (2oldest.sh)"
    echo "    3) Desc                     (3desc.sh)"
    echo "    4) Asc                      (4asc.sh)"
    echo "    5) Type                     (5type.sh)"  
    echo "  0.  Exit"
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
    
    case $choice in
        1)
            echo "Running Most Recent Script..."
            run_script "1most_recent.sh"
            ;;

        2)
            echo "Running Oldest Script..."
            run_script "2oldest.sh"
            ;;

        0)
            echo "Exiting the program."
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


