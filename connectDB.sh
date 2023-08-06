#! /bin/bash
 flag=0
export dbname
  read -p "please enter the database name " dbname
  while [ $flag -eq 0 ]
  do
  if [[ -z $dbname ]]
  then
  echo you must enter the database name to connect
  read -p "please enter the database name " dbname

  elif [[ -d ./databases/$dbname ]]
  then
  flag=1
  . ./TablesMainMenu.sh
  cd ./databases/$dbname 
  else

    echo this database name not exists
    read -p "please enter the database name " dbname  
fi
done
cd ./Bash-Project-DBMS
./Bash-Project-DBMS/DBMainMenu.sh


