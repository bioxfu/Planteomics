library(RColorBrewer)
library(dummies)
col_set <- brewer.pal(n = 9, name = "Set1")

dfm <- read.table('tables/class1-3_genes_list.tsv', header = T, stringsAsFactors = F)
c1 <- dfm[dfm$Class == 'Class1', c('Gene', 'Experiment')]
  
dummy_df <- dummy.data.frame(c1, names=c('Experiment'), sep="_")
gene_freq <- aggregate(dummy_df[,-1], by=list(dummy_df$Gene), FUN=sum)
rownames(gene_freq) <- gene_freq$Group.1
gene_freq <- gene_freq[, -1]
colnames(gene_freq) <- sub('Experiment_', '', colnames(gene_freq))

MPK <- rowSums(gene_freq[, grep('MPK6', colnames(gene_freq))])
MPK[MPK > 0] <- 1
gene_freq$MPK6 <- MPK
gene_freq <- gene_freq[, -grep('MPK6_', colnames(gene_freq))]

write.table(gene_freq, 'tables/class1_genes_in_experiment.tsv', quote=F, sep='\t', col.names = NA)
gene_freq_sum <- table(rowSums(gene_freq))

pdf('figures/class1_genes_in_experiment_barplot.pdf')
bp <- barplot(gene_freq_sum, ylab='Number of Gene', xlab='Number of Experiment', ylim = c(0, max(gene_freq_sum)*1.1), col = col_set[2], border = NA)
text(bp, gene_freq_sum, gene_freq_sum, pos = 3)
dev.off()

