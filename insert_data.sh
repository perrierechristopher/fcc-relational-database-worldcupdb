#! /bin/bash

clear

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate table games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  if [[ $WINNER != null && $OPPONENT != null ]]
  then

    # Check if the team/opponent is part of the teams table already
    WINNER_IN_TABLE=$($PSQL "select team_id from teams where name = '$WINNER'")
    if [[ -z $WINNER_IN_TABLE && $WINNER != winner ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
    fi

    OPPONENT_IN_TABLE=$($PSQL "select team_id from teams where name='$OPPONENT'")
  
    if [[ -z $OPPONENT_IN_TABLE && $OPPONENT != opponent ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
    fi

  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

  if [[ -z $WINNER_ID || -z $OPPONENT_ID ]]
  then
    continue
  else
    INSERTING_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi

done