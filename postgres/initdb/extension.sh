#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --dbname "$POSTGRES_DB" <<-EOSQL
        CREATE EXTENSION tablefunc;
        CREATE EXTENSION dict_xsyn;
        CREATE EXTENSION fuzzystrmatch;
        CREATE EXTENSION pg_trgm;
	CREATE EXTENSION CUBE;
EOSQL
