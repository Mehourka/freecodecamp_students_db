#!/bin/bash
# Program To insert new elemtns into periodic_table database

PSQL="psql --no-align -t -U freecodecamp -d periodic_table -c"
echo "Please provide an element as an argument."
read ELEMENT

# Check if input is Atomic Number
if [[ $ELEMENT =~ ^[0-9]+$ ]]; then
  ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT")
fi


# Check if input is Symbol
if [[ -z $ELEMENT_ID ]]; then
  ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT'")
fi

# Check if input is Name
if [[ -z $ELEMENT_ID ]]; then
  ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT'")
fi

if [[ -z $ELEMENT_ID ]]
then
  echo "Element not found"
else
  echo "Element found"
fi