#!/bin/bash
source_folder=$1
dest_hdfs=$2

hdfs dfs -mkdir -p $dest_hdfs

for f in $source_folder*.tbl*
do
    hadoop fs -put $f $dest_hdfs
    echo "$f was inserted into $dest_hdfs in hadoop"
done
