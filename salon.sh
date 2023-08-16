#!/bin/bash
# Salon Appointment Program

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){

  if [[ $1 ]]; then
    echo -e "\n$1"
  fi

  # list the actual services in the DB
  echo "$($PSQL "SELECT * FROM services")" | while read SERVICE_ID BAR SERVICE
  do
    echo "$SERVICE_ID) $SERVICE"
  done

  # Read user choice
  read SERVICE_ID_SELECTED
  
  # Check choice validity
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]; then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    #get number
    GET_PHONE_NUMBER
    # Make appointment
    MAKE_APPOINTMENT
  fi

}

GET_PHONE_NUMBER() {

  # ask for phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # Check if phone number is valid => XXX-XXXX
  if [[ ! $CUSTOMER_PHONE =~ ^[0-9]{3}-[0-9]{3}-[0-9]{4}$ ]]; then
    echo -e "\nInvalid entry\nPlease enter a valid phone nuber (eg: 555-555-5555)\n"
    GET_PHONE_NUMBER;
  else
    # If phone number in db
    # Add it
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    # else
    if [[ -z $CUSTOMER_NAME ]]; then
      # Ask for user name and register it
      ADD_CUSTOMER
    fi
    # Get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
}

ADD_CUSTOMER() {
  # Read User name
  echo -e "\nI don't have a record for that phone number, what's your name?";
  read CUSTOMER_NAME
  # Add new customer to database
  ADD_CUSTOMER_RESTUL=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
}

MAKE_APPOINTMENT() {
  # Get the appointment time
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # Add new appointment to table
  ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # print the success
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU

#echo "User chose : $MAIN_MENU_CHOICE"
