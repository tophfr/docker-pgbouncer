#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 -U admin1 dbtest2 <<-EOSQL
    CREATE TABLE table1 (id serial PRIMARY KEY, field1 INT NOT NULL DEFAULT 0);

    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES    IN SCHEMA public TO user1;
    GRANT USAGE, SELECT                  ON ALL SEQUENCES IN SCHEMA public TO user1;
    GRANT EXECUTE                        ON ALL FUNCTIONS IN SCHEMA public TO user1;
EOSQL

psql -v ON_ERROR_STOP=1 -U admin2 dbtest3 <<-EOSQL
    CREATE TABLE table1 (id serial PRIMARY KEY, field1 INT NOT NULL DEFAULT 0);

    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES    IN SCHEMA public TO user2;
    GRANT USAGE, SELECT                  ON ALL SEQUENCES IN SCHEMA public TO user2;
    GRANT EXECUTE                        ON ALL FUNCTIONS IN SCHEMA public TO user2;
EOSQL
