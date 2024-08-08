#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE teams, games")"q

cat games.csv | while IFS="," read _ _ NAME_1 NAME_2 _ _
do
	if [[ $NAME_1 != "winner" ]]
	then
    	NAME_1_CHECK="$($PSQL "SELECT name FROM teams WHERE name='$NAME_1'")"
    	if [[ -z $NAME_1_CHECK ]]
    	then
    		echo "$($PSQL "INSERT INTO teams(name) VALUES('$NAME_1')")"
    	fi

    	if [[ -z "$($PSQL "SELECT name FROM teams WHERE name='$NAME_2'")" ]]
    	then
    		echo "$($PSQL "INSERT INTO teams(name) VALUES('$NAME_2')")"
    	fi
    fi
done	

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_G OPPONENT_G
do
	if [[ $WINNER != "winner" ]]
	then
		WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
		OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
		echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
		VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_G, $OPPONENT_G)")"
	fi
done