#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]; then
	echo "Please provide an element as an argument."
else
	NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE CAST (atomic_number AS VARCHAR) = '$1' OR name = '$1' OR symbol = '$1'")
	if [[ -z $NUMBER ]]; then
		echo "I could not find that element in the database."
	else
		INFO="$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
		FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id)
		WHERE atomic_number = $NUMBER ")" 
    
		IFS="|" read _ NAME SYMBOL TYPE MASS MELT BOIL <<< $INFO
		echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."		  
	fi
fi

# Hey these ~15 lines of code took me a while!
# CAST() really helped
# But maybe I shouldn't have used them since they weren't introduced in the courses
# Anyway, thanks and bye~