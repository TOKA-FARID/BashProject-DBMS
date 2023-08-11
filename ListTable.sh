#!/bin/bash
export LC_COLLATE=C             #Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex


ListTablesFun() {
#while true; do
#read -p "Enter your database name: " db_name
#if [[ ! -d "databases/$dbname" ]]; then
#echo "Sorry, Database with name '$dbname' does not exist. "
#read -p "Enter 'q' to quit or 'Enter' to continue: " choice
#  if [[ "$choice" == "q" ]]; then
#            echo "Exiting..."
#            bash ./ListTable.sh
#    fi 
#else
read -p "Enter table name to list: " tbl_name
if [[ -f ./databases/$dbname/$tbl_name ]]; then
  echo "Contents of $tbl_name: "
  cat ./databases/$dbname/$tbl_name
else
  echo "Sorry, Table '$tbl_name' does not found in database '$dbname'" 
fi 
#fi
#done
}

echo "========= TABLE MENU =========="
options=("List table" "Go back to tables menu")
select opt in "${options[@]}"
do
case $opt in
    "List table" ) 
      ListTablesFun
      break
      ;;
    "Go back to tables menu" ) 
      echo "Exiting..."
      . ./TablesMainMenu.sh
      ;;
    *)
      echo "Invalid option" 
      ;;
  esac
done

. ./TablesMainMenu.sh