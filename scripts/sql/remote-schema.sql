-- Add extension
CREATE EXTENSION postgres_fdw;

-- Link Server
CREATE SERVER steampipe_remote 
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (
        host 'steampipe',
        port '9193',
        dbname 'steampipe'
    );
-- Map User
CREATE USER MAPPING FOR postgres
        SERVER steampipe_remote
        OPTIONS (user 'steampipe', password 'steampipe');

/*
    For each new plugin you will need to run the following commands
    Be sure to replace `github` with the plugin name.
*/

-- Create schema to map to
CREATE SCHEMA steampipe_github;

-- Import remote schema
IMPORT FOREIGN SCHEMA github FROM SERVER steampipe_remote INTO steampipe_github;