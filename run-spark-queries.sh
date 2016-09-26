#!/bin/bash
source_folder=$1
DB=$2
inclusivity=$3 # inc[lude] or exc[lude]
match_pattern=$4

echo "Source folder = $source_folder"

run_query () {
    query=$1
    echo -e "use $DB;\n$(cat $query)" > spark-$query_name
    spark-sql -i $source_folder/testbench.settings -f spark-$query_name > $source_folder/$DB/out-${query_name%.*} 2>&1
}

for query in $source_folder/tpch_query*.sql
do
    query_name=$(basename "$query")
    echo -n "  Handling query: $query_name -> "

    if [[ $inclusivity =~ "inc" ]] ; then
        if [[ $query_name =~ $match_pattern ]] ; then   # Including files
            echo -n "Executing... "
            run_query $query
            echo "Done!"
        else
            echo "Skipped."
        fi
    else
         if ! [[ $query_name =~ $match_pattern ]] ; then   # Excluding files
            echo -n "Executing... "
            run_query $query
            echo "Done!"
        else
            echo "Skipped."
        fi
    fi
done
