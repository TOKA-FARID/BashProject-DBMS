#! /bin/bash

echo "Welcome to Our DataBase Main Menu: "
PS3='Please enter your choice: '
options=("Show Databases" "Use Database" "Create New Database" "Delete Database" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Show Databases") 
         ./showDB.sh
        ;;
        "Use Database") 
        pwd
        ;;
        "Create New Database") 
        pwd
        ;;
        "Delete Database") 
        ;;
        "Quit") exit
        ;;
        *) echo "Invalid option $REPLY"
        ;;
    esac
done