#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n===== Welcome to this salon. ====="

MAIN_MENU(){
echo -e "\nAvailable services:"
SERVICES=$($PSQL "SELECT * FROM services")
echo "$SERVICES" | while read SERVICE_ID _ SERVICE_NAME
do
	echo "$SERVICE_ID) $SERVICE_NAME"
done

read SERVICE_ID_SELECTED
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_NAME ]]
then
	echo "Invalid option."
	MAIN_MENU
else
	echo -e "\nPlease type your phone number:"
	read CUSTOMER_PHONE
	CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
	if [[ -z $CUSTOMER_NAME ]]
	then
		echo -e "\nThere's no customer record for that phone number. Please enter your name:"
		read CUSTOMER_NAME
		NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    echo $CUSTOMER_NAME $CUSTOMER_PHONE
	fi
	echo -e "\nAt what time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
	read SERVICE_TIME

	CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")	
	NEW_APP=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
	echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi
}

MAIN_MENU
