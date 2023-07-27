#!/bin/bash

while true
do
  echo -e "\nAdding new planet entry :"
  read -p '  Name : ' name
  has_atmosphere=$(($RANDOM % 2))
  mass=$((1000 + $RANDOM % 10000))
  planet_id=$(($RANDOM % 12))
  is_habitable=$((RANDOM % 2))
  query="INSERT INTO moon(name, has_atmosphere, mass, planet_id, is_habitable) VALUES ('$name', '$has_atmosphere', '$mass', '$planet_id', '$is_habitable');"
  echo -e "$query\n"
  psql -U freecodecamp -d universe -c "$query"

  read -p 'continue ? (y/n)  ' again
  if [ "$again" != "y" ]  ; then 
    break
  fi
done
