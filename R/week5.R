# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import
Adata_tbl <- read_delim("../data/Aparticipants.dat", delim = "-", col_names = c("casenum", "parnum","stimver", "datadate", "qs"))
Anotes_tbl <- read_csv("../data/Anotes.csv")
Bdata_tbl <- read_delim("../data/Bparticipants.dat", col_names = c("casenum", "parnum","stimver", "datadate", paste0("q",1:10))) # Why deleting delim works? 
Bnotes_tbl <- read_tsv("../data/Bnotes.txt") # read_delim works too

# Data Cleaning
Aclean_tbl <- Adata_tbl %>%
  separate_wider_delim(qs, delim = "-", names = paste0("q", 1:5)) %>%
  mutate(datadate = mdy_hms(datadate)) %>%
  mutate(across(contains("q"), ~ as.integer(.))) %>%
  left_join(Anotes_tbl, by = "parnum") %>%
  filter(is.na(notes))
ABclean_tbl <- Bdata_tbl %>% 
  mutate(datadate = mdy_hms(datadate)) %>%
  mutate(across(contains("q"), ~ as.integer(.))) %>%
  left_join(Bnotes_tbl, by = "parnum") %>%
  filter(is.na(notes)) %>%
  bind_rows(Aclean_tbl, .id = "lab")  %>% #Stack two tables on top with an identifier column 
  select(-notes)
  
  