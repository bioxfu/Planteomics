library(readxl)

files <-  dir('table_20180510', '*.xlsx', full.names = T)
x <- NULL
for (file in files) {
  cat(file, '\n')
  dfm <- read_excel(file, sheet = 1, skip = 1)
  x <- rbind(x, dfm[1,1:2])
}

x$`Name of Sheet` <- sub('Table S', '', x$`Name of Sheet`)
x$`Name of Sheet` <- sub('-1', '', x$`Name of Sheet`)
x$Experiment <- sub('This table lists all identified 18O-phosphopeptides from ', '', x$Experiment)
x$Experiment <- sub(' in vitro kinase reaction of ', '_', x$Experiment)
x$Experiment <- sub('-treated Arabidopsis\\.* \\(Class I substrate\\)\\.*', '', x$Experiment)

colnames(x)[1] <- 'Table'
x <- x[order(as.numeric(x$Table)),]
x$Table <- paste0('S', x$Table)
write.table(x, 'tables/table_and_experiment.tsv', quote = T, sep = '\t', row.names = F)
