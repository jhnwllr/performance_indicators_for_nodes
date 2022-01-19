#!/bin/bash
echo "on remote"
hdfs dfs -rm nodes.tsv
hdfs dfs -put nodes.tsv