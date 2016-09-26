# Description
Small scripts created to help with the TPC-H benchmarking

# Scripts
* `put-into-hdfs.sh` is simply a loop that puts the files in **source_folder** into hadoop **dest_hdfs** folder
* `run-spark-queries.sh` executes tpch queries in spark

# Parameters for run-spark-queries
`run-spark-queries.sh` takes 4 parameters in order:
1. **source_folder** The path to the queries folder (and testbench.settings)
2. **DB** The database name to be used in the execution of the queries
3. **inclusivity** A string to define if the *match_pattern* (that's parameter #4) will be _inclusive_ or _exclusive_
4. **match_pattern** Regex string to be used in the matching of the queries names to execute

## Examples
  ./run-spark-queries.sh /mnt/hive-testbench/sample-queries-tpch/ tpch_flat_parquet_1000 include "(query6|query14)"
  ./run-spark-queries.sh /mnt/hive-testbench/sample-queries-tpch/ tpch_flat_orc_100 exclude "(query1\.|query11)"