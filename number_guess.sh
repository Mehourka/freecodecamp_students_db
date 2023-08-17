#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# Programm that makes you guess a random number

# Guessing game round
PLAY_ROUND() {
  # Print first argument if given
  if [[ $1 ]]; then
    echo -e "$1"
  fi

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
    fi
  fi
}

# Set random target number 
TARGET=$(( RANDOM % 1000 + 1))

# Fetch user name
echo "Enter your username:"
read USER_NAME

# If username exists
if false; then
  # gather user stats
  # print greeting and stats
  echo "Should not print"
# else
else
  # greet new user
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
  # register new user
fi

echo "Guess the secret number between 1 and 1000:"

PLAY_ROUND
