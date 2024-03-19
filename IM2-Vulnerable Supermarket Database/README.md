## How to import supermarket.sql database
1. Login as postgres user: `sudo -u postgres psql` or `psql -U postgres` -
2. create database: `CREATE DATABASE supermarket`
3. Log out: `CTRL + D` or  `\q`
4. Import database: `$ psql -d supermarket -U postgres -f supermarket.sql` - NOTE: make sure you working in the same directory.
5. 

NOTE: If you having issues importing the database make sure to check the `pg_ident.conf` file and ensure that the user `postgres` login method is set to `md5` and not `peer`.