#!/bin/bash
echo "starting R script"
eval `ssh-agent -s`
ssh-add
Rscript.exe R/get_node_data.R
echo "export to remote"
scp -r data/nodes.tsv jwaller@c5gateway-vh.gbif.org:/home/jwaller/
echo "load to hdfs"
ssh jwaller@c5gateway-vh.gbif.org 'bash -s' < shell/load_to_hdfs.sh
echo "load spark script"
scp -r scala/pin.scala jwaller@c5gateway-vh.gbif.org:/home/jwaller/
ssh jwaller@c5gateway-vh.gbif.org 'spark2-shell -i pin.scala'
rm /mnt/c/Users/ftw712/desktop/archive/performance_indicators_for_nodes/data/performance_indicators_nodes.tsv
wget -P /mnt/c/Users/ftw712/desktop/archive/performance_indicators_for_nodes/data http://download.gbif.org/custom_download/jwaller/performance_indicators_nodes.tsv
echo "post processing R script"
Rscript.exe R/post_processing.R
