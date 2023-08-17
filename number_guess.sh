#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
# Programm that makes you guess a random number

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
