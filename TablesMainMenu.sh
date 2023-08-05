#!/bin/bash

echo "Welcome to Our Tables Main Menu in DataBase: "
PS3='Please enter your choice: '
options=("Create Table" "Show Table" "Drop Table" "Insert into Table" "Select from Table" "Delete from Table" "Update Table" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Create Table")
            bash ./CreateTable.sh
        ;;
        "List Table")
            bash ./ListTable.sh
        ;;
        "Drop Table")
            bash ./DropTable.sh
        ;;
        "Insert into Table")
            bash ./InsertIntoTable.sh
        ;;
	    "Select from Table")
	        bash ./SelectFromTable.sh
	    ;;
        "Delete from Table")
	        bash ./DeleteFromTable.sh
	    ;;
	    "Update Table")
            bash ./UpdateTable.sh
	    ;;
        "Quit") exit
        ;;
        *) echo "Invalid option $REPLY"
        ;;
    esac
done