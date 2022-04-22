# post processing 

library(dplyr)

# setwd("C:/Users/ftw712/Desktop/archive/performance_indicators_for_nodes/data/")

"data/performance_indicators_nodes.tsv" %>%
readr::read_tsv() %>% 
group_by(node_key,node_title) %>%
summarise(had_additions = any(occ_diff > 0)) %>%
ungroup() %>% 
select(node_title,yes_no = had_additions) %>%
mutate(node_new_records = ifelse(yes_no,"yes","no")) %>% 
select(-yes_no) %>%
glimpse() %>% 
readr::write_tsv("data/node_published_new_records.tsv")

quit(save="no")
