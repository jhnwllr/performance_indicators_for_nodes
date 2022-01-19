# post processing 

library(dplyr)

data_dir = "C:/Users/ftw712/Desktop/performance_indicators_for_nodes/data/"

# need filler data first 
xlsx_df = "Nodes Indicators 2021.xlsx" %>% 
paste0(data_dir,.) %>%
readxl::read_excel(sheet = "Indicators") %>%
select(node_name = `Node name`)

pid_df = "performance_indicators_nodes.tsv" %>%
paste0(data_dir,.) %>%
readr::read_tsv() 

missing_nodes_names = xlsx_df$node_name[!xlsx_df$node_name %in% pid_df$node_title]
missing_df = data.frame(node_title = missing_nodes_names,yes_no = "no")

yes_no_df = pid_df %>% 
group_by(node_key,node_title) %>%
mutate(had_additions = any(occ_diff > 0)) %>%
ungroup() %>%
filter(node_title %in% xlsx_df$node_name) %>% 
select(node_title,yes_no = had_additions) %>%
mutate(yes_no = ifelse(yes_no,"yes","no")) %>%
unique() %>%
rbind(missing_df) %>% 
glimpse()

if(!nrow(xlsx_df) == nrow(yes_no_df)) stop("source rows not equal")

# paste into excel 
yes_no_df[match(xlsx_df$node_name,yes_no_df$node_title),] %>%
pull(yes_no) %>% 
cat(sep="\n")

quit(save="no")

