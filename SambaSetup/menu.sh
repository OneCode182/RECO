#!/bin/sh
# Menu Shell script using case statement with execution permission checks

# Function to display the menu options
show_menu() {
    echo "-----------------------------------------------------"
    echo "            NetBSD - Samba Setup Script              "
    echo "-----------------------------------------------------"
    echo "    1) Install Samba"
    echo "    2) Config User & Access"    
    echo "    3) Samba Config Files"  
    echo "    4) Start Services"      
    echo "    5) Restart Services"  
    echo "    6) Stop Services"  
    echo "    7) Status Services"  
    echo "                                                     "
    echo "    0)  Exit                                         "
    echo "-----------------------------------------------------"
}


# Function to wait for user input to continue
press() {
    read -p "Press any key to continue..." var
}

while true; do
    show_menu
    # Read user choice
    read -p "Enter your choice: " choice
    
    case $choice in
        1)
            # Data
            pkgin -y update
            pkgin -y install samba
            samba -V

            press
            ;;

        2)
            # USER NAME & PASSWORD
            user_name="usersamba" 
            useradd -m $user_name
            passwd $user_name

            # CREATE DIRECTORY SAMBA SERVER
            echo "Creating Directory Server..."
            server_dir="/home/Server"
            mkdir $server_dir

            # Group
            group="grpsamba"
            groupadd $group
            usermod -G grpsamba $group

            # Access
            echo "Set Access Group User..."
            chown -R :$group $server_dir
            chmod -R 770 $server_dir

            echo "Samba User Setup..."
            smbdpasswd -a $user_name
            smbdpasswd -e $user_name

            press

            ;;

        3)
            
            
            # Backups
            echo "Creating Backups..."
            cd /usr/pkg/etc/samba
            cp smb.conf smb.conf.bak
            > ./smb.conf
            
            # Copy Template
            echo "Copying Template smb.conf..."
            cp smb_tmp.conf smb.conf
            mv smb.conf /usr/pkg/etc/samba/
            testparm

            # Adding Services
            echo "Adding Services /etc/rc.conf file..."
            echo "" >> /etc/rc.conf
            echo "# SAMBA CONFIG" >> /etc/rc.conf
            echo "nmbd=YES" >> /etc/rc.conf
            echo "smbd=YES" >> /etc/rc.conf
            echo "winbindd=YES" >> /etc/rc.conf

            echo "Copying Services to /etc/rc.d/"
            ln -sf /usr/pkg/share/examples/rc.d/nmbd /etc/rc.d/nmbd
            ln -sf /usr/pkg/share/examples/rc.d/smbd /etc/rc.d/smbd
            ln -sf /usr/pkg/share/examples/rc.d/winbindd /etc/rc.d/winbindd
            ln -sf /usr/pkg/share/examples/rc.d/samba /etc/rc.d/samba
            press


            ;;
        4)
            
            service smbd start
            service nmbd start
            service winbindd start
            press
            ;;
        
        5)
            
            service smbd restart
            service nmbd restart
            service winbindd restart
            press
            ;;

        6)
            
            service smbd stop
            service nmbd stop
            service winbindd stop
            press
            ;;


        7)
            

            # Verificar el estado de los servicios y formatearlo en tabla
            echo -e "Service\t\tStatus"
            echo -e "-------------------------------"

            # Comprobar el estado de smbd, nmbd y winbindd
            for service in smbd nmbd winbindd; do
                status=$(systemctl is-active $service)  # Verificar el estado del servicio
                echo -e "$service\t\t$status"
            done

            press

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


