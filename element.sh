#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1

if [[ -z $INPUT ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = "$INPUT"")
    OUTPUT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER ")
    echo $OUTPUT | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
    do
      echo The element with atomic number $ATOMIC_NUMBER is $NAME "($SYMBOL)". "It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  else
    #USING SYMBOL
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$INPUT'")
    if [[ -z $SYMBOL ]]
    then
      #USING NAME
      NAME=$($PSQL "SELECT name FROM elements WHERE name = '$INPUT'")
      if [[ -z $NAME ]]
      then
        echo I could not find that element in the database.
      else
        OUTPUT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$NAME' ")
        echo $OUTPUT | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
        do
          echo The element with atomic number $ATOMIC_NUMBER is $NAME "($SYMBOL)". "It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi
    else
      OUTPUT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$SYMBOL' ")
      echo $OUTPUT | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
      do
        echo The element with atomic number $ATOMIC_NUMBER is $NAME "($SYMBOL)". "It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi
fi
