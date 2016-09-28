#!/bin/bash
src_folder=$1
program=$2
DB=$3
inclusivity=$4 # inc[lude] or exc[lude]
match_pattern=$5

# Do some minimal parameter check
if [ "X$src_folder" = "X" ]; then
	echo "Need a src_folder to look for scripts."
    exit 1
fi
if [ "X$program" = "X" ]; then
	echo "Need an executable program name that supports flags -i for initialization settings and -f for query file (e.g. hive, spark-sql)."
    exit 1
fi
if [ "X$DB" = "X" ]; then
	echo "Need a DB name to run the queries against. You can list them in , for example, hive with 'show databases;'."
    exit 1
fi
if [ "X$inclusivity" = "X" ]; then
	echo "Need a specified inclusivity. Supports 'inc[clude]' or any other string for exclusive behaviour."
    exit 1
fi
if [ "X$match_pattern" = "X" ]; then
	echo "Need a match_pattern pair with inclusivity and match with the sql queries names."
    exit 1
fi

# Make sure output dir exists
output_dir="$src_folder/out-$program-$DB"
mkdir -p $output_dir

run_query () {
    # Add the 'use DB;' statement to the beggining of each query
    echo -e "use $DB;\n$(cat $query_file)" > "$output_dir/$program-$query_name"
    $program -i "$src_folder/testbench.settings" -f "$output_dir/$program-$query_name" > "$output_dir/out-${query_name%.*}" 2>&1
}

for query_file in $src_folder/tpch_query*.sql
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
