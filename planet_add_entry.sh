#!/bin/bash

while true
do
  echo -e "\nAdding new planet entry :"
  read -p '  Name : ' name
  read -p '  Moon number : ' number_of_moons
  read -p '  has_life : ' has_life
  read -p '  Earth size_ratio : ' earth_size_ratio
  read -p '  star_id : ' star_id
  query="INSERT INTO planet(name, number_of_moons, has_life, earth_size_ratio, star_id) VALUES ('$name', '$number_of_moons', '$has_life', '$earth_size_ratio', '$star_id');"
  echo -e "$query\n"
  psql -U freecodecamp -d universe -c "$query"

  read -p 'continue ? (y/n)  ' again
  if [ "$again" != "y" ]  ; then 
    break
  fi
done
