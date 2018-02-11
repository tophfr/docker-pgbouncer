#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 -U user1 dbtest2 <<-EOSQL
     INSERT INTO table1 (field1) SELECT * FROM generate_series(1, 10000, 2);
EOSQL

psql -v ON_ERROR_STOP=1 -U user2 dbtest3 <<-EOSQL
     INSERT INTO table1 (field1) SELECT * FROM generate_series(10000, 1, -1);
EOSQL
