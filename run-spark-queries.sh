#!/bin/bash
source_folder=$1
DB=$2
inclusivity=$3 # inc[lude] or exc[lude]
match_pattern=$4

# DB="use tpch_flat_orc_100;"
# DB="use tpch_flat_parquet_100;"
use_DB="use $DB;"

echo "source folder = $source_folder"

for query in $source_folder/tpch_query*.sql
do
    query_name=$(basename "$query")
    echo "Query name is $query_name"

    if [[$inclusivity =~ "inc"]] ; then
        if [[ $query_name =~ $match_pattern ]] ; then   # Including files
            echo -e "$DB\n$(cat $query)" > spark-$query_name
            spark-sql -i testbench.settings -f spark-$query_name > $source_folder/sparkOutput-parquet/out-${query_name%.*} 2>&1
        else
            echo "Skipping query $query"
    else
         if ! [[ $query_name =~ $match_pattern ]] ; then   # Excluding files
            echo -e "$DB\n$(cat $query)" > spark-$query_name
            spark-sql -i testbench.settings -f spark-$query_name > $source_folder/sparkOutput-parquet/out-${query_name%.*} 2>&1
        else
            echo "Skipping query $query"

    fi
done
