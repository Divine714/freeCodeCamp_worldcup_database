#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# winner_name
if [[ $WINNER != "winner" ]]
then
  WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

  if [[ -z $WINNER_NAME ]]
  then
    WINNER_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ WINNER_INSERT == "INSERT 0 1" ]]
      then
        echo Inserted team, $WINNER
      fi
  fi
fi

# opponent_name
if [[ $OPPONENT != "opponent" ]]
then
  OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

  if [[ -z $OPPONENT_NAME ]]
  then
    OPPONENT_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ OPPONENT_INSERT == "INSERT 0 1" ]]
      then
        echo Inserted team, $OPPONENT
      fi
  fi
fi

#games table
if [[ $YEAR != "year" ]]
then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  Game_INSERT=$($PSQL "INSERT INTO games(winner_id, opponent_id, year, round, winner_goals, opponent_goals) VALUES($WINNER_ID, $OPPONENT_ID, $YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS)")
fi

done
