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
    echo "    0)  Exit                                         "
    echo "-----------------------------------------------------"
}


# Function to wait for user input to continue
press() {
    read -p "Press any key to continue..." var
}

# VARS
USER="usersamba"
GROUP="groupsamba"
DIR_SHARE="/home/Server"
DIR_SERVICES="/usr/pkg/share/examples/rc.d/"
DIR_RC="/etc/rc.d/"
DIR_SMB_CONF="/usr/pkg/etc/samba/"


while true; do
    show_menu
    # Read user choice
    read -p "Enter your choice: " choice
    
    case $choice in
        1)
            # Data
            echo "[COMMAND] -> Pkgin: Updating Mirrorlist"
            pkgin -y update

            echo "[COMMAND] -> Pkgin: Installing Samba"
            pkgin -y install samba

            echo "[COMMAND] -> Samba: Verify Instalation"
            samba -V

            press
            ;;

        2)
            # USER NAME & PASSWORD
            useradd -m $USER
            echo "[INFO] -> useradd: User Created"

            echo "[CMD] -> passwd: Set User Password..."
            passwd $USER
            echo "[INFO] -> User Password Done"

            # CREATE DIRECTORY SAMBA SERVER
            echo "[COMMAND] -> Mkdir: Creating Directory Server..."
            mkdir $DIR_SHARE
            echo "[INFO] -> $DIR_SHARE Created"

            # Group
            echo "[CMD] -> groupadd/usermod: Setup UserGroup"
            groupadd $GROUP
            usermod -G $GROUP $USER

            # Access
            echo "[CMD] -> chown/chmod: Security Dir"
            chown -R :$GROUP $DIR_SHARE
            chmod -R 770 $DIR_SHARE

            echo "[CMD] smbpasswd: Set User to Samba"
            smbpasswd -a $USER
            smbpasswd -e $USER


            # END
            echo "[DONE] -> Script Executed"
            press

            ;;

        3)
            
            
            
            
            # Copy Template
            echo "[INFO] -> Copying Template smb.conf..."
            cp smb_tmp.conf $DIR
            testparm

            # Backups
            echo "Creating Backups..."
            cd $DIR_SMB_CONF

            cp smb.conf smb.conf.bak
            mv smb_tmp.conf smb.conf


            # Agregar Servicios al archivo /etc/rc.conf
            echo "[INFO] Add Services to /etc/rc.conf file..."

            cat << EOF >> /etc/rc.conf

            # SAMBA CONFIG
            nmbd=YES
            smbd=YES
            winbindd=YES 
EOF

            echo "[INFO] -> Copying Services to /etc/rc.d/"
            ln -sf "$DIR_SERVICES"nmbd "$DIR_RC"nmbd
            ln -sf "$DIR_SERVICES"smbd "$DIR_RC"smbd
            ln -sf "$DIR_SERVICES"winbindd "$DIR_RC"winbindd
            ln -sf "$DIR_SERVICES"samba "$DIR_RC"samba
            
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
                status=$(service $service status)  # Verificar el estado del servicio
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


