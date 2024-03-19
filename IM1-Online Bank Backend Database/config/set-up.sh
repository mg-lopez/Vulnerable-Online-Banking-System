#!/bin/bash

# Define the name of the database
DB_NAME="bank5"

# Define the path to the database dump file
DB_DUMP="$HOME/bank/dump.sql"

# Create a new database
createdb $DB_NAME

# Import the database dump file into new database
psql $DB_NAME < $DB_DUMP

# Confirm that the import was succesful
echo "Database Import Complete."

