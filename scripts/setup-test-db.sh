#!/bin/bash

# Download demo database
wget 'https://www.postgresqltutorial.com/wp-content/uploads/2019/05/dvdrental.zip' -O dvdrental.zip
unzip dvdrental.zip

# Load demo database
pg_restory --dbname postgres://postgres:postgres@localhost ./dvdrental.tar

# Clean up
rm dvdrental.zip
rm dvdrental.tar