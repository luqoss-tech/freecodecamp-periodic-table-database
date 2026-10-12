#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# program behaviour
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# check if input is atomic_number, symbol or name
if [[ $1 =~ ^[0-9]+$ ]]
then
  INPUT_CONDITION="atomic_number=$1"
else
  INPUT_CONDITION="symbol='$1' OR name='$1'"
fi

# query database
QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE $INPUT_CONDITION")

# check query result  
if [[ -z $QUERY_RESULT ]]
then
  # if result is empty
  echo "I could not find that element in the database."
else
  # if result is found
  echo "$QUERY_RESULT" | while IFS="|" read ATOMIC_ID SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi
