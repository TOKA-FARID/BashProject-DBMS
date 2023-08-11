#!/bin/bash

# Define the path to the databases folder
DB_PATH="databases"

# Define a function to display the menu options
display_menu () {
  echo "Please choose one of the following options:"
  echo "1) Drop a table from the database"
  echo "2) Back to the menu"
}

# Define a function to drop a table from the database
drop_table () {
  # Check if the databases folder exists
  if [[ ! -d "$DB_PATH" ]]; then
    echo "The databases folder does not exist."
    return
  fi
  # Get the list of databases in the folder
  DATABASES=$(ls $DB_PATH)
  # Check if there are any databases
  if [[ -z "$DATABASES" ]]; then
    echo "There are no databases in the folder."
    return
  fi
  # Display the list of databases and ask the user to choose one
  echo "The databases in the folder are:"
  echo "$DATABASES"
  # Loop until the user enters a valid database name or 'q' to go back
  while true; do
    #read -p "Enter the name of the database you want to connect to or 'q' to go back: " db_name
    # Check if the user wants to go back
    #if [[ "$db_name" = "q" || "$db_name" = "Q" ]]; then
     # return
    #fi
    # Check if the database name is valid
    if [[ ! -d ./$DB_PATH/$dbname ]]; then
      echo "Invalid database name. Please try again."
    else
      break
    fi
  done  
  # Get the list of tables in the database
  tables=$(ls ./$DB_PATH/$dbname)
  # Check if there are any tables
  if [[ -z "$tables" ]]; then
    echo "There are no tables in the database."
    return
  fi
  # Display the list of tables and ask the user to choose one
  echo "The tables in the database are:"
  echo "$tables"
  # Loop until the user enters a valid table name or 'q' to go back
  while true; do
    read -p "Enter the name of the table you want to drop or 'q' to go back: " tbl_name
    # Check if the user wants to go back
    if [[ "$tbl_name" = "q" || "$tbl_name" = "Q" ]]; then
      return
    fi  
    # Check if the table name is valid
    if [[ ! -f ./$DB_PATH/$dbname/$tbl_name ]]; then
      echo "Invalid table name. Please try again."
    else
      break
    fi  
  done  
  # Ask for confirmation before dropping the table
  read -p "Are you sure you want to delete the table $tbl_name? (y/n) " confirm
  # Check if the user confirmed
  if [[ "$confirm" = "y" || "$confirm" = "Y" ]]; then
    # Drop the table from the database by deleting the file
    rm  ./$DB_PATH/$dbname/$tbl_name
    rm  ./$DB_PATH/$dbname/$tbl_name-metadata

    echo "The table $tbl_name has been deleted from the database."
  else
    echo "The table $tbl_name has not been deleted from the database."
  fi  
}

# Display the menu and loop until the user goes back to the main menu
while true; do  
  display_menu  
  read -p "Enter your choice: " choice  
  case $choice in  
    1) drop_table ;;  
    2) bash ./TablesMainMenu.sh ;;  
    *) echo "Invalid choice." ;;  
  esac  
done  

#echo "You have returned to the main menu."
