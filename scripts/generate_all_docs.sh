#!/usr/bin/env bash
set -xeuo pipefail

if [ "${1-}" = "" ]
then
    echo >&2 "Usage: $0 duckdb_dir_with_debug_duckdb"
    exit 1
fi

DUCKDB=$1;
echo "Generating docs using duckdb source in $DUCKDB"

python3 ./scripts/generate_config_docs.py $DUCKDB/build/debug/duckdb
python3 ./scripts/generate_docs.py $DUCKDB
python3 ./scripts/generate_python_docs.py
node ./scripts/generate_nodejs_docs.js $DUCKDB
python3 ./scripts/generate_function_json.py --source $DUCKDB --binary $DUCKDB/build/debug/duckdb

# generate search index last, once all the docs are generated
python3 ./scripts/generate_search.py
