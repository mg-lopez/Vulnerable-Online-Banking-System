# This README.txt details how to set up the Online-Banking System

IMPORTANT: Save online-bank folder under $HOME directory BEFORE running any scripts.

# File Locations
- Set-up script is located under => "$HOME/online-bank/conf/set-up.sh" 
- Database dump file is located under => "$HOME/online-bank/dump.sql" 


IMPORTANT: Do Not change the location of the scripts

# Steps
## Run Set-Up Script to prepare environment
1. $ chmod +x $HOME/online-bank/conf/set-up.sh
2. $ cd $HOME/online-bank/conf/
3. $ ./set-up.sh

## Run Test Script to prove the functionality of the database
1. $ chmod +x $HOME/online-bank/test-script.sh
2. $ cd $HOME/online-bank/
3. $ ./test-script.sh
