#!/bin/bash

# Set Database Variables
DB_NAME="bank5"
DB_USER="m1gu3l"       # Change to "customer" to show case both roles permissions
DB_PASS="13agosto2002"    # Chnage to "customer123" for "customer" role

# Connect to the database as the "manager/customer" role
export PGPASSWORD=DB_PASS
psql -U $DB_USER -d $DB_NAME -h localhost

# Test the customer table by inserting a sample customer and retrieve the inserted data
echo "Testing the customer table"
echo "Inserting a sample customer"
psql -U $DB_USER -d $DB_NAME -c "INSERT INTO customer (fname, lname, phone_number, email, password, gender, date_of_birth, street_addr, house_addr, city, postcode, employment_status, income) 
VALUES ('Manuel', 'Fransisco', '1234567890', 'test123@email.com', 'password123', 'M', '1990-01-01', '26 Avenue', 'Apt 2', 'LA', 'NW3 6DJ', 'Employed', 50000);"
echo "Retrieving the inserted customer data"
psql -U $DB_USER -d $DB_NAME -c "SELECT * FROM customer WHERE fname = 'Manuel' AND lname = 'Fransisco';"

# Test the account table by inserting a sample account and retrieve the inserted data
echo "Testing the account table"
echo "Inserting a sample account"
psql -U $DB_USER -d $DB_NAME -c "INSERT INTO account (customer_id, account_type, account_number, short_code, card_number, card_expiry, card_cvv, credit_limit, balance) 
VALUES (1, 'Savings', 123456789, 'ABCD1234', 12345678, '2024-01-01', 123, 100000, 0);"
echo "Retrieving the inserted account data"
psql -U $DB_USER -d $DB_NAME -c "SELECT * FROM account WHERE account_number = 123456789;"

# Insert another sample account data for the customer
psql -U $DB_USER -d $DB_NAME -c "INSERT INTO account (customer_id, account_type, account_number, short_code, card_number, card_expiry, card_cvv, credit_limit, balance)
VALUES (1, 'Current', 9876543210, 'WXYZ5678', 9876543210, '2025-12-31', 456, '100000.00', '50000.00')"

# Test the loan_application table by inserting a sample loan application and retrieve the inserted data
echo "Testing the loan_application table"
echo "Inserting a sample loan application"
psql -U $DB_USER -d $DB_NAME -c "INSERT INTO loan_application (account_id, date, requested_amount, is_approved, approved_amount) 
VALUES (1, '2022-12-31', 50000, true, 50000);"
echo "Retrieving the inserted loan application data"
psql -U $DB_USER -d $DB_NAME -c "SELECT * FROM loan_application WHERE account_id = 1;"

# Test the loan_payment table by inserting a sample loan payment and retrieve the inserted data
echo "Testing the loan_payment table"
echo "Inserting a sample loan payment"
psql -U $DB_USER -d $DB_NAME -c "INSERT INTO loan_payment (loan_application_id, loan_status, total_amount, repayment_frequency, next_payment_date, next_payment_amount, outstanding_amount) 
VALUES (1, 'Approved', 50000, 'Monthly', '2022-12-31', 5000, 45000);"
echo "Retrieving the inserted loan payment data"
psql -U $DB_USER -d $DB_NAME -c "SELECT * FROM loan_payment WHERE loan_application_id = 1;"

# Insert transfer data
psql -U $DB_USER -d $DB_NAME -c "INSERT INTO transfer (date, customer_id, transfer_type, sender_id, receiver_id, amount)
VALUES (current_timestamp, 1, 'Funds Transfer', 1, 2, 25000.00)"
psql -U $DB_USER -d $DB_NAME -c "SELECT * FROM transfer;"
