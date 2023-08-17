#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# Programm that makes you guess a random number

# Guessing game round
PLAY_ROUND() {
  # Print first argument if given
  if [[ $1 ]]; then
    echo -e "$1"
  fi

  # Increment number of moves
  CURRENT_MOVES=$(( CURRENT_MOVES + 1 ))
  
  # Fetch Guess from user
  read ROUND_GUESS
  # Check if it's an integer
  if [[ ! $ROUND_GUESS =~ ^[0-9]+$ ]]
  then
    # reset round
    PLAY_ROUND "That is not an integer, guess again:"
  else
    # Check if win 
    if [[ TARGET -lt ROUND_GUESS ]]; then
      PLAY_ROUND "It's lower thant that, guess again:"
    elif [[ TARGET -gt ROUND_GUESS ]]; then
      PLAY_ROUND "It's higher thant that, guess again:"
    else
      echo "YOU WIN !!!";
      # Register the win in games table
      REGISTER_GAME
    fi
  fi
}

REGISTER_GAME() {
  # Check if user exists
  if [[ -z $USER_ID ]]; then
    # If not, add him to users table
    INSERT_USER_RESULT=$($PSQL "INSERT INTO users(name) VALUES('$USER_NAME')")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USER_NAME'")
  fi
  # register game to games table
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, move_count) VALUES($USER_ID, $CURRENT_MOVES)")
}

# Set random target number 
TARGET=$(( RANDOM % 1000 + 1))
CURRENT_MOVES=0

echo -e "DEBUG - Target $TARGET"

# Fetch user name
echo "Enter your username:"
read USER_NAME

# Get user ID
USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USER_NAME'")

# If username exists
if [[ ! -z $USER_ID ]]; then
  # gather user stats
  GAME_COUNT=
  BEST_SCORE=
  # print greeting and stats
  echo "Should not print"
# else
else
  # greet new user
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
fi

echo "Guess the secret number between 1 and 1000:"

PLAY_ROUND
