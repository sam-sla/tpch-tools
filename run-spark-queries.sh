#!/bin/bash
source_folder=$1
DB=$2
inclusivity=$3 # inc[lude] or exc[lude]
match_pattern=$4

echo "Source folder = $source_folder"

# Make sure output dir exists
output_dir="$source_folder/output-$DB"
mkdir -p $output_dir

run_query () {
    echo -e "use $DB;\n$(cat $query_file)" > "$output_dir/spark-$query_name"
    spark-sql -i $source_folder/testbench.settings -f "$output_dir/spark-$query_name" > "$output_dir/out-${query_name%.*}" 2>&1
}

for query_file in $source_folder/tpch_query*.sql
do
    query_name=$(basename "$query_file")
    echo -n "  Handling query file: $query_name -> "

    if [[ $inclusivity =~ "inc" ]] ; then
        if [[ $query_name =~ $match_pattern ]] ; then   # Including files
            echo -n "Executing... "
            run_query
            echo "Done!"
        else
            echo "Skipped."
        fi
    else
         if ! [[ $query_name =~ $match_pattern ]] ; then   # Excluding files
            echo -n "Executing... "
            run_query
            echo "Done!"
        else
            echo "Skipped."
        fi
    fi
done
