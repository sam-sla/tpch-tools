#!/bin/bash
source_folder=$1
exclude_pattern=$2

DB="use tpch_flat_orc_100;"

echo "source folder = $source_folder"

for query in $source_folder/tpch_query*.sql
do
    query_name=$(basename "$query")
    echo "Query name is $query_name"
#    echo "Exclude pattern is: $exclude_pattern"

#    if ! [[ $query_name =~ $exclude_pattern ]] ; then # Excluding files
    if [[ $query_name =~ $exclude_pattern ]] ; then   # Including files
      #echo "BASH_REMATCH = $BASH_REMATCH"
#      echo "Will process query $query_name"
      echo -e "$DB\n$(cat $query)" > spark-$query_name
      spark-sql -i testbench.settings -f spark-$query_name > $source_folder/sparkOutput/out-${query_name%.*} 2>&1
    else
      echo "Skipping query $query"
    fi
done
