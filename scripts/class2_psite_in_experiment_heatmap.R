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
  c2 <- read_excel(file, sheet = 3, skip = 1)
  c2_psite <- unique(sort(c2$`T: Sequence window`))
  x <- rbind(x, cbind(c2_psite, expt))
}
colnames(x) <- c('Psite', 'Experiment')
x <- as.data.frame(x)

dummy_df <- dummy.data.frame(x, names=c('Experiment'), sep="_")
psite_freq <- aggregate(dummy_df[,-1], by=list(dummy_df$Psite), FUN=sum)
rownames(psite_freq) <- psite_freq$Group.1
psite_freq <- psite_freq[, -1]
colnames(psite_freq) <- sub('Experiment_', '', colnames(psite_freq))

pdf('figures/class2_psite_in_experiment_heatmap.pdf', hei=8, wid=4)
pheatmap(psite_freq, show_rownames = F, col=colorRampPalette(c('gray95', col_set[1]))(100), legend = F)
dev.off()
system('./scripts/pheatmap_pdf_cleaner.sh figures class2_psite_in_experiment_heatmap.pdf')
