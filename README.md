## performance indicators for nodes

This script answers this question:

> B. Were new records published in 2021 by institutions endorsed by the node?

##  run 

```
cd performance_indicators_for_nodes
bash run.sh
```

## output

The output is this file `data\node_published_new_records.tsv`. Will give **yes** or **no** answer to the question above. 


## Keep in mind

* This script does **not** include **eBird** or **iNaturalist** contributions from nodes. 
* To run next year, you will need to update the snapshot dates in `pin.scala`.

