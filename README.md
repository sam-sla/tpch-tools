## Description
Small scripts created to help with the TPC-H benchmarking

## Scripts
- `put-into-hdfs.sh` is simply a loop that puts the files in **src_folder** into hadoop **dest_hdfs** folder
- `run-queries.sh` executes tpch queries in the provided program name (e.g. spark-sql or hive)

### Parameters for run-spark-queries
`run-spark-queries.sh` takes 5 parameters in order:

1. **src_folder** The path to the queries folder (and testbench.settings)
2. **program** The name of the program that will take and execute the queries
3. **DB** The database name to be used in the execution of the queries
4. **inclusivity** A string to define if the *match_pattern* (that's parameter #4) will be _inclusive_ or _exclusive_
5. **match_pattern** Regex string to be used in the matching of the queries names to execute

#### Examples
* `$ ./run-queries.sh /mnt/hive-testbench/sample-queries-tpch/ spark-sql tpch_flat_parquet_1000 include "(query6|query14)"`
* `$ ./run-queries.sh /mnt/hive-testbench/sample-queries-tpch/ hive tpch_flat_orc_100 exclude "(query1\.|query11)"`

## Credits
These scripts were written in complement to https://github.com/hortonworks/hive-testbench
