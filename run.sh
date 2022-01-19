#!/bin/bash
echo "starting R script"
Rscript.exe R/pin.R
echo "export to remote"
scp -r data/nodes.tsv jwaller@c5gateway-vh.gbif.org:/home/jwaller/
echo "load to hdfs"
ssh jwaller@c5gateway-vh.gbif.org 'bash -s' < load_to_hdfs.sh
echo "load spark script"
scp -r scala/pid.scala jwaller@c5gateway-vh.gbif.org:/home/jwaller/
ssh jwaller@c5gateway-vh.gbif.org 'spark2-shell -i pid.scala'
rm /mnt/c/Users/ftw712/desktop/pid/data/performance_indicators_nodes.tsv
wget -P /mnt/c/Users/ftw712/desktop/performance_indicators_for_nodes/data http://download.gbif.org/custom_download/jwaller/performance_indicators_nodes.tsv
echo "post processing R script"
Rscript.exe R/post_processing.R
