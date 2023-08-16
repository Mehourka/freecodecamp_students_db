#!/bin/bash
# Salon Appointment Program

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){
  # Echo the first argument if there are
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
  
  # Check Service exists
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]; then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    # Get customer number
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    # If user dosn't exist in db
    if [[ -z $CUSTOMER_NAME ]]; then
      # Ask for user name and register it
      ADD_CUSTOMER
    fi
    # Make appointment
    MAKE_APPOINTMENT
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

  # Get Customer ID
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # Add new appointment to table
  ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # print on success
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
