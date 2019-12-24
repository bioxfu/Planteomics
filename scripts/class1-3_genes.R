library(readxl)

dfm <- read.table('tables/table_and_experiment.tsv', header = T, stringsAsFactors = F)

x <- NULL
for (i in 1:nrow(dfm)) {
  table_name <- dfm[i, 1]
  expt <- dfm[i, 2]
  file <- paste0('table_20180510/Supplementary Table ', table_name, '.xlsx')
  cat(file, '\n')
  
  c1 <- read_excel(file, sheet = 2, skip = 1)
  c1_gene <- unique(sort(sub('\\..+', '', unlist(strsplit(c1$Proteins, ';')))))
  c2 <- read_excel(file, sheet = 3, skip = 1)
  c2_gene <- unique(sort(sub('\\..+', '', unlist(strsplit(c2$`T: Proteins`, ';')))))
  c3 <- read_excel(file, sheet = 6, skip = 1)
  
  if (nrow(c3) > 0) {
    c3_gene <- unique(sort(sub('\\..+', '', unlist(strsplit(c3$`T: Proteins`, ';')))))
    c123 <- cbind(expt, rbind(cbind('Class1', c1_gene), cbind('Class2', c2_gene), cbind('Class3', c3_gene)))
  }
  else {
    c123 <- cbind(expt, rbind(cbind('Class1', c1_gene), cbind('Class2', c2_gene)))
  }
  colnames(c123) <- c('Experiment', 'Class', 'Gene')
  x <- rbind(x, c123)
}
x <- as.data.frame(x)
write.table(x, 'tables/class1-3_genes_list.tsv', quote = T, sep = '\t', row.names = F)

stat <- do.call(cbind, lapply((tapply(x$Class, x$Experiment, table)), as.data.frame))
rownames(stat) <- stat[,1]
stat <- stat[,grep('Freq', colnames(stat))]
colnames(stat) <- sub('.Freq', '', colnames(stat))
n <- stat['Class1',]
stat <- stat[, order(n, decreasing = T)]

dfm2 <- merge(dfm, t(stat), by.x = 2, by.y = 0)
dfm2 <- dfm2[order(dfm2$Class1, decreasing = T), ]
write.table(dfm2, 'tables/class1-3_genes_summary.tsv', quote = F, sep = '\t', row.names = F)

pdf('figures/class1-3_genes_barplot.pdf')
par(mar=c(9,5,4,2))
rownames(stat) <- c('Class I', 'Class II', 'Class III')
barplot(as.matrix(stat), beside = T, legend.text = T, las=3, ylim=c(0, max(n)*1.1), ylab='Number of Genes')
dev.off()

