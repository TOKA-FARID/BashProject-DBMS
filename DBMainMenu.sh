#! /bin/bash

echo "Welcome to Our DataBase Main Menu :)"
PS3='Please enter your choice: '

options=("Show Databases" "Connect Database" "Create New Database" "Delete Database" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Show Databases") 
        . ./showDBs.sh
        ;;
        "Connect Database") 
        . ./connectDB.sh
        ;;
        "Create New Database")
        . ./createDB.sh 
        ;;
        "Delete Database") 
        . ./deleteDB.sh
        ;;
        "Quit") exit
        ;;
        *) echo "Invalid option $REPLY"
        ;;
    esac
done
