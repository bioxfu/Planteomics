library(readxl)
library(dplyr)

dfm <- read.table('tables/table_and_experiment.tsv', header = T, stringsAsFactors = F)

detected <- NULL
induced <- NULL

for (i in 1:nrow(dfm)) {
  table_name <- dfm[i, 1]
  expt <- dfm[i, 2]
  file <- paste0('table_20180510/Supplementary Table ', table_name, '.xlsx')
  cat(file, '\n')
  
  t1 <- read_excel(file, sheet = 2, skip = 1) %>% select(Proteins, Sequence, 'Modified sequence') %>% mutate(Type='vitro', Diff=0, Experiment=expt, Class='I')
  t2 <- read_excel(file, sheet = 3, skip = 1) %>% select(Proteins='T: Proteins', Positions='T: Positions within proteins', Diff=contains("N: Student's T-test Difference")) %>% mutate(Type='vitro', Experiment=expt, Class='II')
  t3 <- read_excel(file, sheet = 4, skip = 1) %>% select(Proteins, Sequence, 'Modified sequence') %>% mutate(Type='vivo', Diff=0, Experiment=expt, Class='unclassified')
  t4 <- read_excel(file, sheet = 5, skip = 1) %>% select(Proteins='T: Proteins', Positions='T: Positions within proteins', Diff=contains("N: Student's T-test Difference")) %>% mutate(Type='vivo', Experiment=expt, Class='unclassified')
  t5 <- read_excel(file, sheet = 6, skip = 1) %>% select(Proteins='T: Proteins', Positions='T: Positions within proteins', Diff=contains("N: Student's T-test Difference")) %>% mutate(Type='vitro_and_vivo', Experiment=expt, Class='III')
  detected <- rbind(detected, t1, t3)
  if (nrow(t5) > 0) {
    induced <- rbind(induced, t2, t4, t5)
  }
  else {
    induced <- rbind(induced, t2, t4)
  }
}

detected <- filter(detected, !is.na(Proteins)) %>% as.data.frame()
induced <- filter(induced, !is.na(Proteins)) %>% as.data.frame()

write.table(detected, 'tables/combine_supp_tables_detected.tsv', quote = F, sep = '\t', row.names = F, col.names = F)
write.table(induced, 'tables/combine_supp_tables_induced.tsv', quote = F, sep = '\t', row.names = F, col.names = F)
