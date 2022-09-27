#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  #if no first argument given ask for one
  echo "Please provide an element as an argument."
else
  #if there is a first arugment...
  #get the atomic number
  #if the input is a number search by atomic number...
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #search by number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
  else
    #search by text
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE (symbol='$1' OR name='$1');")
  fi
  #if the atomic number is blank output fail
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    #get all the other info about the element
    ELEMENT_DATA=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;")
    #echo $ELEMENT_DATA
    echo "$ELEMENT_DATA" | while read TYPE_ID BAR ANUM BAR ELEMENT_SYMBOL BAR ELEMENT_NAME BAR ELEMENT_WEIGHT BAR MPC BAR BPC BAR ELEMENT_TYPE
    do
      echo "The element with atomic number $ANUM is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_WEIGHT amu. $ELEMENT_NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi
fi
