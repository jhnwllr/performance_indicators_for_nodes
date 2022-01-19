# create node_data.tsv

print("starting R")
library(dplyr) 
library(purrr)
# filter(type == "COUNTRY") %>% 

jsonlite::fromJSON("https://api.gbif.org/v1/node?&limit=1000")$results %>% 
select(node_key=key,node_title=title) %>% 
glimpse() %>% 
mutate(dataset_list = node_key %>% 
map(~
paste0("https://api.gbif.org/v1/node/",.x,"/dataset?") %>%
gbifapi::page_api("results",1000,10,TRUE) %>%
modify_if(is.null, ~ list(key=NA)) %>%
map_chr(~ .x$key)
)) %>%
tidyr::unnest(cols = c(dataset_list)) %>%
select(node_title,node_key,datasetkey=dataset_list) %>% 
readr::write_tsv("C:/Users/ftw712/Desktop/pid/data/nodes.tsv")

quit(save="no")

