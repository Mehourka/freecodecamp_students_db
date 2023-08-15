#!/bin/bash
# Salon Appointment Program

PSQL="psql -U freecodecamp -d salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){

  echo -e $1

  #echo -e "\n1) Haricut\n2) Beard trim\n3) Wash\n"
  
  # list the actual services in the DB
  echo "$($PSQL "SELECT * FROM services")" | while read SERVICE_ID BAR SERVICE; do
    echo "$SERVICE_ID) $SERVICE"
  done

  # Read user choice
  read MAIN_MENU_CHOICE
  case $MAIN_MENU_CHOICE in
    1) GET_PHONE_NUMBER ;;
    2) echo "Beard trim chosen";;
    3) echo "Wash chosen";;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac

}

GET_PHONE_NUMBER() {

  # ask for phone number
  echo -e "\nWhat's your phone number?"
  read USER_PHONE
  # Check if phone number is valid => XXX-XXX-XXXX
  if [[ ! $USER_PHONE =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]; then
    echo -e "\nInvalid entry\nPlease enter a valid phone nuber (eg: 555-555-5555)\n"
    GET_PHONE_NUMBER;
  else
    # If phone number in db
    USER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$USER_PHONE'")
    if [[ -z $USER_NAME ]]; then
      ADD_CUSTOMER
      echo -e "\nDEBUG - Added into customers, $USER_NAME\n"
    fi
  fi
  # ask for appointment time
  # else
  # Ask for user name and register it

}

ADD_CUSTOMER() {
  # Read User name
  echo -e "\nI don't have a record for that phone number, what's your name?";
  read USER_NAME
  # Add new customer to database
  $($PSQL "INSERT INTO customers(name, phone) VALUES('$USER_NAME', '$USER_PHONE')")
  return $USER_NAME
}

MAIN_MENU "\nWelcome to My Salon, how can I help you?"

