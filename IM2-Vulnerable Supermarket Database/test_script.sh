#!/bin/bash

# Database credentials
DATABASE="supermarket"
USERNAME="postgres"
PASSWORD=" " # Enter postgres password here

# Function to run psql commands
run_psql() {
    PGPASSWORD=$PASSWORD psql -U $USERNAME -d $DATABASE -c "$1"
}

# Insert test data
run_psql "INSERT INTO employee.\"Employee\" (emp_id, name, address, date_of_birth, sort_code, bank_account_number, salary) 
VALUES (1, 'John Doe', '123 Main St', '1985-01-01', 'SC001', 'BA001', 50000.00),
       (2, 'Jane Smith', '456 High St', '1986-02-02', 'SC002', 'BA002', 55000.00),
       (3, 'Richard Roe', '789 Park Ave', '1987-03-03', 'SC003', 'BA003', 60000.00);"

run_psql "INSERT INTO employee.\"EmployeeJobDetails\" (emp_id, area_id, store_id, department_id, job_role) 
VALUES (1, 1, 1, 1, 'Store_manager'),
       (2, 2, 2, 2, 'HR_manager'),
       (3, 3, 3, 3, 'Finance_manager');"

# Test SELECT privileges for Case 1
run_psql "SET ROLE \"Store_manager\"; SELECT name, address FROM employee.\"Employee\";"
run_psql "SET ROLE \"HR_manager\"; SELECT name, address, date_of_birth, salary FROM employee.\"Employee\";"
run_psql "SET ROLE \"Finance_manager\"; SELECT name, address, date_of_birth, sort_code, bank_account_number, salary FROM employee.\"Employee\";"

# Test Audit Logger for Case 3
run_psql "SET ROLE \"admin\"; SELECT * FROM audit_table;"