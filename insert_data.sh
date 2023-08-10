#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

function INSERT_TEAM() {
  if [[ -z $1 ]]; then return; fi

  # Check if team already in teams
  TEAM_IN_TABLE=$($PSQL "SELECT team_id FROM teams WHERE name='$1'")
  # if not
  if [[ -z $TEAM_IN_TABLE ]]; then
    INSERT_RETURN=$($PSQL "INSERT INTO teams(name) VALUES('$1')")
    if [[ $INSERT_RETURN == "INSERT 0 1" ]]; then
    echo "Inserted into teams, $1"
    fi
  fi
}

function INSERT_GAME() {

  WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  COLUMNS="year, round, winner_id, opponent_id, winner_goals, opponent_goals"
  VALUES="$YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WIN_GOALS, $OPP_GOALS"
  INSERT_GAME_RETURN=$($PSQL "INSERT INTO games($COLUMNS) VALUES($VALUES)")
}

# Delete data
echo $($PSQL "TRUNCATE games, teams")

# loop through each entry in the games.csv file
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS; do
  # Skip first row

  if [[ $YEAR == "year" ]]; then continue; fi
  # ~~ teams ~~
  # insert into teams
  INSERT_TEAM "$WINNER"
  INSERT_TEAM "$OPPONENT"

  # ~~ games ~~
  INSERT_GAME
done