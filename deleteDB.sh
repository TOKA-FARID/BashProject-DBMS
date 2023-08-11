#! /bin/bash
 read -p "please enter the database name " dbname
 flag=0
  while [ $flag -eq 0 ];do
 
  if [[ -d ./databases/$dbname ]]
  then
  rm -r ./databases/$dbname
  echo this database is deleted 
  flag=1
  elif [[ -z $dbname ]]
  then
  echo you must enter the database name
  read -p "please enter the database name " dbname

  else
    echo this database name not exists
    read -p "please enter the database name " dbname
  fi
  done
  
  . ./DBMainMenu.sh