#!/bin/bash

docker exec steampipe steampipe plugin install github;

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd );

psql --dbname 'postgres://postgres:postgres@localhost:5432/postgres' < $SCRIPT_DIR/sql/remote-schema.sql;

psql --dbname 'postgres://postgres:postgres@localhost:5432/postgres' < $SCRIPT_DIR/sql/test-query.sql;