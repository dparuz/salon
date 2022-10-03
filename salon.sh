#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n\n~~~~~ Edel's Salon ~~~~~~\n\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  
  echo -e "\n1) Haircut\n2) Dye\n3) Peeling\n4) Nails\n5) Style"
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]$ ]]
  then
    MAIN_MENU "Please select a valid service id."
  # if valid selection ask for phone number
  else
  echo -e "\nPlease enter your phone number."
  read CUSTOMER_PHONE
  PHONE_RESULT=$($PSQL "SELECT * FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
    # if phone not found: add new customer
    if [[ -z $PHONE_RESULT ]]
      then
      echo -e "\nMay I have your name, please?"
      read CUSTOMER_NAME
      ADD_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
  # customer & Id
  CUSTOMER_NAME=$($PSQL "SELECT name from customers where phone='$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL "SELECT customer_id from customers where phone='$CUSTOMER_PHONE'")

  # appointment
  echo "At what time would you like to come?"
  read SERVICE_TIME

  #Add appointment
  INSERT_APP_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME', '$CUSTOMER_ID', '$SERVICE_ID_SELECTED')")

  #output success message
  SERVICE=$($PSQL "SELECT name from services where service_id=$SERVICE_ID_SELECTED")
  echo -e "I have put you down for a$SERVICE at $SERVICE_TIME,$CUSTOMER_NAME." 
  fi
}


MAIN_MENU "Please select a service"
