#!/bin/bash

# Display the tables in the database
echo "..Here You Can Update Your Tables.."
echo "Tables in the $dbname database:"
ls ./databases/$dbname/$tablename

# Get the user's choice of whether to update the data or metadata or return back.
while [[ $update_choice != "q" ]]; do
# Ask the user if they want to update the table data or metadata
echo "Do you want to update the data or metadata? (data/metadata). or type 'q' to return back.."
read update_choice
# Check if the user input is one of these data, metadata, or q
if [[ $update_choice != "data" && $update_choice != "metadata" && $update_choice != "q" ]]; then
echo "Sorry, Invalid choice. Please enter 'data', 'metadata', or 'q'."
continue
fi

while [[ $table_choice != "q" ]]; do
# Update table data
# Ask the user which table they want to update
echo "Which table do you want to update?"
read table_choice

# Check if the table exists
# if [[ ! -f "./databases/$dbname/$tablename" ]]; then
# echo "The table $table_choice does not exist."

    # Ask the user to try again or type 'q' to return back
    read -p "Do you want to try again (y/q)? " choice

    # If the user chooses to try again, loop back to the beginning of the while loop
    if [[ $choice == "y" ]]; then
      continue
    # If the user chooses to return back, exit the script
    elif [[ $choice == "q" ]]; then
      exit 0
    fi
  fi

  # If the user chooses to update the data, get the record and column they want to update.
  if [ "$update_choice" == "data" ]; then
    # Get the PK from the metadata file
    pk=$(sed -n '1p' ./databases/$dbname/$tablename-metadata | cut -d ':' -f 1)
    # Check if the PK is an int
    if [[ $pk == "id" ]]; then
      datatype="int"
    else
      datatype="string"
    fi

    # Ask the user which record they want to update? (specify by PK)
    echo "Which record do you want to update? (specify by PK)"
    read pk_choice
    # Check if the PK exists
    if [[ ! $(grep -q "^$pk_choice:" ./databases/$dbname/$tablename) ]]; then
      echo "The record with PK=$pk_choice does not exist."
      continue
    fi

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
# Check if the data type is valid
datatype=$(head -n $col_choice ./databases/$dbname/$tablename-metadata | cut -d ':' -f 2)

if [[ "$datatype" == "int" ]]; then
  if [[ ! -z "$(echo $new_data | grep -E '[a-zA-Z]')" ]]; then
    echo "Invalid data type. Please enter only numbers for int column."
    continue
  fi
elif [[ "$datatype" == "string" ]]; then
  if [[ -z "$(echo $new_data | grep -E '[a-zA-Z0-9]')" ]]; then
    echo "Invalid data type. Please enter only strings for string column."
    continue
  fi
fi

    # Replace the old data with the new data
    sed -i "/^$pk_choice:/s/[^:]*\(:\|$\)/$new_data\1/$col_choice" ./databases/$dbname/$tablename
    echo -e "the data has been successfully updated :)"
  fi
done

# If the user chooses to update the metadata..
if [[ $update_choice == "metadata" ]]; then
    # Update table metadata
    # Ask the user if they want to change the PK, change a datatype, or add a new column
    echo "Do you want to change the PK, change a datatype, or add a new column? (pk/datatype/column)"
    read metadata_choice

# Check if the metadata change is valid
if [[ ! metadata_choice =~ ^(?:pk|datatype|column) ]]; then
  echo "Sorry, Invalid choice. Please enter 'pk', 'datatype', or 'column'."
  continue
fi

# Change the PK
if [ "$metadata_choice" == "pk" ]; then
# Ask the user for the new PK column number
echo "Which column do you want to set as the new PK? (specify by column number)"
read new_pk
# Check if the new PK is valid
if [[ -z $new_pk ]]; then
  echo "Please enter a value for the new PK."
  continue
fi
# Check if the new PK column is a number
if [[ $datatype == "int" ]] && ! [[ $new_pk =~ ^[0-9]+$ ]]; then
  echo "Sorry, New PK must be a number of column"
  continue
fi
# Check if the new PK is already in use
if [[ $(grep -w "$new_pk" ./databases/$dbname/$tablename-metadata) ]]; then
  echo "The PK $new_pk is already in use."
  continue
fi

# Update the PK in the metadata file
sed -i "1s/.*/pk:$new_pk/" ./databases/$dbname/$tablename-metadata
echo -e "The PK has been successfully updated :)"


  # Change a datatype
  elif [ "$metadata_choice" == "datatype" ]; then
    # Ask the user which column they want to change the datatype of
      echo "Which column do you want to change the datatype of? (specify by column number)"
      read col_choice
    # Check if the column number is valid
    if [[ $col_choice -lt 1 || $col_choice -gt $(wc -l < ./databases/$dbname/$tablename-metadata) ]]; then
      echo "The column number $col_choice is invalid."
      continue
    fi
    
    # Get the current datatype of the column
    current_datatype=$(head -n $col_choice ./databases/$dbname/$tablename-metadata | tail -n 1)

    # Ask the user for the new datatype
    echo "What datatype do you want to change $current_datatype to?"
    read new_datatype

    # Check if the new datatype is compatible with the current datatype
    if [[ ! $(echo "$current_datatype $new_datatype" | awk '{ print $1 == $2 }') ]]; then
       echo "The new datatype $new_datatype is not compatible with the current datatype $current_datatype."
       continue
    fi
        # Update the datatype in the metadata file
        sed -i "2s/[^:]*\(:\|$\)/$new_datatype\1/$col_choice" ./databases/$dbname/$tablename-metadata
    
    elif [ "$metadata_choice" == "column" ]; then
        # Add a new column
        # Ask the user for the datatype of the new column
        echo "What is the datatype of the new column? (int/string)"
        read new_datatype

        # Add the new datatype to the metadata file
        sed -i "2s/$/:$new_datatype/" ./databases/$dbname/$tablename-metadata

        # Ask the user for the data for each record in this new column and add it to each record in table data file.
        while IFS= read -r line; do 
            pk=$(echo $line | cut -d ':' -f 1)
            echo "Enter data for record with PK=$pk"
            read record_data 
            sed -i "/^$pk:/s/$/:$record_data/" ./databases/$dbname/$tablename 
        done < ./databases/$dbname/$tablename
    fi
else 
  echo "Invalid choice. Please enter 'data', 'metadata', or 'q' to return back."
fi
done
