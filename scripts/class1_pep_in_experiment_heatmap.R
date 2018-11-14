library(readxl)
library(dummies)
library(pheatmap)
library(RColorBrewer)
col_set <- brewer.pal(n = 9, name = "Set1")

dfm <- read.table('tables/table_and_experiment.tsv', header = T, stringsAsFactors = F)
x <- NULL
for (i in 1:nrow(dfm)) {
  table_name <- dfm[i, 1]
  expt <- dfm[i, 2]
  file <- paste0('table_20180510/Supplementary Table ', table_name, '.xlsx')
  cat(file, '\n')
  c1 <- read_excel(file, sheet = 2, skip = 1)
  c1_pep <- unique(sort(c1$Sequence))
  x <- rbind(x, cbind(c1_pep, expt))
}
colnames(x) <- c('Peptide', 'Experiment')
x <- as.data.frame(x)

dummy_df <- dummy.data.frame(x, names=c('Experiment'), sep="_")
pep_freq <- aggregate(dummy_df[,-1], by=list(dummy_df$Peptide), FUN=sum)
rownames(pep_freq) <- pep_freq$Group.1
pep_freq <- pep_freq[, -1]
colnames(pep_freq) <- sub('Experiment_', '', colnames(pep_freq))

pdf('figures/class1_pep_in_experiment_heatmap.pdf', hei=10, wid=4)
pheatmap(pep_freq, show_rownames = F, col=colorRampPalette(c('gray95', col_set[1]))(100), legend = F)
dev.off()
system('./scripts/pheatmap_pdf_cleaner.sh figures class1_pep_in_experiment_heatmap.pdf')
