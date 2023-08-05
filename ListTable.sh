#!/bin/bash
export LC_COLLATE=C             #Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex


ListTablesFun() {
while true; do
read -p "Enter your database name: " db_name
if [[ ! -d "databases/$db_name" ]]; then
echo "Sorry, Database with name '$db_name' does not exist. "
read -p "Enter 'q' to quit or 'Enter' to continue: " choice
   if [[ "$choice" == "q" ]]; then
            echo "Exiting..."
            bash ./ListTable.sh
    fi 
else
read -p "Enter table name to list: " tbl_name
if [[ -f "databases/$db_name/$tbl_name" ]]; then
   echo "Sorry, Table '$tbl_name' does not found in database '$db_name'"  
else
   echo "Contents of $tbl_name: "
   cat "databases/$db_name/$tbl_name"
fi
fi
done
}

echo "========= TABLE MENU =========="
options=("List table" "Exit")
select opt in "${options[@]}"
do
case $opt in
    "List table" ) 
      ListTablesFun
      break
      ;;
    "Exit" ) 
      echo "Exiting..."
      bash ./TablesMainMenu.sh
      ;;
    *)
      echo "Invalid option" 
      ;;
  esac
done