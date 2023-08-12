#!/bin/bash
export LC_COLLATE=C             # Terminal Case Sensitive
shopt -s extglob                #import Advanced Regex

echo "********************************"
echo "..Here You Can Update Tables.."
echo "********************************"
echo "Tables in the $dbname database:"
ls ./databases/$dbname/$tablename

# Get the user's choice of whether to update the data or metadata or return back.
while [[ $update_choice != "q" ]]; do
# Ask the user if they want to update the table data or metadata
echo "Do you want to update a specific record (r) or the metadata (m) of the table? (r/m): or type 'q' to return back.."
read update_choice
# Check if the user input is one of these data, metadata, or q
if [[ $update_choice != "r" && $update_choice != "m" && $update_choice != "q" ]]; then
echo "Sorry, Invalid choice. Please enter 'r', 'm', or 'q'."
continue
fi

while true; do
# Update table data
# Ask the user which table they want to update
echo "Which table do you want to update?"
ls ./databases/$dbname/$tablename
echo "============================"
read tablename

# Check if the table_choice variable is empty
if [[ -z $tablename ]]; then
  echo "Please enter a table name."
  continue
fi

# Check if the table_choice variable is a valid table name
if [[ ! -f ./databases/$dbname/$tablename ]]; then
  echo "The table $tablename does not exist."

  # Ask the user to try again or type 'q' to return back
  read -p "Do you want to try again (y/q)? " choice

  # If the user chooses to try again, loop back to the beginning of the while loop
  if [[ $choice == "y" ]]; then
    continue
  # If the user chooses to return back, exit the script
  elif [[ $choice == "q" ]]; then
    exit 0
  fi
  else
    # Table exists, break out of the inner while loop
  break
  fi
done

  # If the user chooses to update the data, get the record and column they want to update.
  if [[ $update_choice == "r" ]]; then
  # Get the PK column name from the metadata file
  pk_column=$(sed -n '1p' ./databases/$dbname/$tablename-metadata | cut -d ':' -f 2)
  # Ask the user which record they want to update? (specify by PK)
  echo "Which record do you want to update? (specify by pk)"
  read pk_choice

  # Ask the user which column they want to update
  echo "Which column do you want to update? (specify by column number)"
  read col_choice
  # Check if the col_choice is a number
    if [[ ! $col_choice -ge 1 && $col_choice -le $(wc -l < ./databases/$dbname/$tablename) ]]; then
       echo "The column number $col_choice is invalid."
       continue
    fi

    # Ask the user for the new data
    echo "What is the new data you want to enter?"
    read new_data

    # Replace the old data with the new data
    sed -i "/^$pk_choice:/s/[^:]*\(:\|$\)/$new_data\1/$col_choice" ./databases/$dbname/$tablename
    echo "the data has been successfully updated :)"
  
# If the user chooses to update the metadata..
elif [[ $update_choice == "m" ]]; then
    # Update table metadata
    # Ask the user if they want to change the PK, change a datatype, or add a new column
    echo "Do you want to change the PK, change a datatype, or add a new column? (pk/dt/col)"
    read metadata_choice

# Check if the metadata change is valid
if [[ $metadata_choice != "pk" && $metadata_choice != "dt" && $metadata_choice != "col" ]]; then
  echo "Sorry, Invalid choice. Please enter 'pk', 'dt', or 'col'."
  continue
fi

# Change the PK
if [[ $metadata_choice == "pk" ]]; then
  # Ask the user for the new PK name
  echo "What is the new PK name?"
  read new_pk_name

  # Check if the new PK name is valid
  if [[ ! $new_pk_name =~ ^[a-zA-Z]+$ ]]; then
    echo "Invalid PK name. The name must be a string and must not have any spaces, special characters, or numbers."
    continue
  fi

  # Update the PK name in the metadata file
  sed -i "1s/^pk:.*/pk:$new_pk_name/" "./databases/$dbname/$tablename-metadata"
  echo "The PK has been successfully updated :)"
fi

# Change a datatype
if [[ $metadata_choice == "dt" ]]; then
# Ask the user which column they want to change the datatype of
echo "Which column do you want to change the datatype of? (specify by column number)"
read col_choice

# Check if the column number is valid
if [[ $col_choice -lt 1 || $col_choice -gt $(awk -F: 'NR==2{print NF; exit}' ./databases/$dbname/$tablename-metadata) ]]; then
  echo "The column number $col_choice is invalid."
  exit 1
fi

# Get the current datatype of the column
current_datatype=$(head -n 2 ./databases/$dbname/$tablename-metadata | tail -n 1 | cut -d ':' -f $col_choice)

# Ask the user for the new datatype
echo "What datatype do you want to change ($current_datatype) to?"
read new_datatype

# Check if the input is valid
while [[ $new_datatype != "int" && $new_datatype != "string" ]]; do
  echo "Invalid datatype. Please enter either 'int' or 'string'."
  read new_datatype
done

# Update the datatype in the metadata file
sed -i "2s/[^:]*\(:\|$\)/$new_datatype\1/$col_choice" "./databases/$dbname/$tablename-metadata"
echo "The datatype has been successfully updated :)"
fi

# Add a new column
if [[ $metadata_choice == "col" ]]; then
# Ask the user to enter the new column's data type
echo "Please enter the new column's data type (int or string):"
read new_data_type

# Check that the new data type is either int or string
if [[ $new_data_type != "int" && $new_data_type != "string" ]]; then
  echo "Sorry, The new data type must be either int or string."
  exit 1
fi

# Add the new data type to the end of the metadata file
echo -n ":$new_data_type" >> ./databases/$dbname/$tablename-metadata

# Inform the user that the tablename-metadata file has been updated successfully
echo "The $tablename-metadata has been updated successfully."

# Ask the user to enter the data for the new column
echo "Please enter the data for the new column, column by column, based on the data type of each column: "

# Read the data types from the tablename-metadata file
data_types=$( cat ./databases/$dbname/$tablename-metadata )

# Set the IFS variable to split the data types by colon
IFS=":"

# Loop through each data type and ask the user to enter the corresponding column's data
for data_type in $data_types; do
while true; do
  echo "Please enter the data for the $data_type column:"
  read column_data

  # Check that the entered data matches the expected data type
  if [[ $data_type == "int" && ! $column_data =~ ^-?[0-9]+$ ]]; then
    echo "Sorry, The entered data for the $data_type column must be an integer, please enter again.."
  elif [[ $data_type == "string" && ! $column_data =~ ^[a-zA-Z]+$ ]]; then
    echo "Sorry, The entered data for the $data_type column must be a string, please enter again.."
  else
    # If the entered data is valid, break out of the while loop
    break
  fi
  done

  # Add the entered data to the end of the tablename file, using a colon separator
  echo -n "$column_data:" >>  ./databases/$dbname/$tablename
done

# Inform the user that a new column has been created successfully in the tablename file
echo "A new column has been created successfully in the $tablename."
fi
else
  echo "Invalid choice. Please enter 'data', 'metadata', or 'q' to return back."
fi
done