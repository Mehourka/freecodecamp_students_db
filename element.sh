#!/bin/bash
# Program To insert new elemtns into periodic_table database

PSQL="psql --no-align -t -U freecodecamp -d periodic_table -c"

if [[ ! $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

ELEMENT=$1
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
  echo "I could not find that element in the database."
else
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ELEMENT_ID")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ELEMENT_ID")
  TYPE=$($PSQL "SELECT type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number=$ELEMENT_ID")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ELEMENT_ID")
  MELT_TEMP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ID")
  BOIL_TEMP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ELEMENT_ID")

  echo "The element with atomic number $ELEMENT_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_TEMP celsius and a boiling point of $BOIL_TEMP celsius."
fi
