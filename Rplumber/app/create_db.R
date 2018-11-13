library(dplyr)
library(data.table)

db_name <- 'kinase'

## Create a database
my_db <- src_sqlite(db_name, create = TRUE) 
#my_db <- src_sqlite(db_name, create = FALSE) 

## Put data in the database
phospho <- fread('../../tables/combine_supp_tables_reformat.tsv')
colnames(phospho) <- c('siteID', 'gene', 'protein', 'site', 'aa', 'window', 'experiment', 'type', 'class', 'diff')
copy_to(my_db, phospho, temporary = FALSE)

desc <- fread('../../TAIR10_pep_desc_seq.tsv')
colnames(desc) <- c('protein', 'names', 'description', 'sequence')
copy_to(my_db, desc, temporary = FALSE)

domains <- fread('../../tables/domains.tsv')
colnames(domains) <- c('type', 'description', 'begin', 'end', 'length', 'accession', 'entryName', 'taxid', 'order')
copy_to(my_db, domains, temporary = FALSE)
