#! /bin/bash

export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

ShowAllDBFun(){
if [[ -z "$(ls -F ./databases | grep / )" ]]; then         
   echo " Sorry, there is no databse found !!"   
   echo " ***********************************"      
   
else
   ls -F ./databases | grep / | sed -r 's/\S\s*$//' | column -t          
   echo -e "\n"                                                      
fi
}

ShowSpecificDBFun() {
    while true; do
        read -p "Please enter the name of the database you want to display (type 'q' to quit): " user_input
        
        if [[ "$user_input" == "q" ]]; then
            echo "Exiting..."
            bash ./DBMainMenu.sh
        fi
        
        if [[ -d "databases/$user_input" ]]; then
            ls "databases/$user_input"
            break
        else
            echo "Sorry, the database '$user_input' was not found."
            echo "************************************************"      

        fi
    done
}

options=("show all databases" "show specefic database")
    select opt in "${options[@]}"
    do
    case $opt in
        "show all databases")
            ShowAllDBFun
            bash ./DBMainMenu.sh
            
            ;;
        "show specefic database")
            ShowSpecificDBFun
            
            ;;
        *) echo "invalid option $REPLY please try again" 
           echo "list all databases"
           echo "list specefic database" ;;
    esac
    done