#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 
fi  

if [[ $1 =~ ^[0-9]+$ ]]
then
  SELECT_ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
else
  SELECT_ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol='$1' OR name='$1'")
fi

if [[ -z $SELECT_ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit 0
else

  ATOMIC_NUMBER=$(echo "$SELECT_ELEMENT" | cut -d'|' -f1)
  
  PROPERTIES_SELECT=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
  
  IFS='|' read -r MASS MELTING_POINT BOILING_POINT TYPE <<< "$PROPERTIES_SELECT"

  echo "$SELECT_ELEMENT" | while IFS='|'  read ATOMIC_NUMBER SYMBOL NAME
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done

fi


