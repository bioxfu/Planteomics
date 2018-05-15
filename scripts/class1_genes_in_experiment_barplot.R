library(RColorBrewer)
col_set <- brewer.pal(n = 9, name = "Set1")

dfm <- read.table('tables/class1-3_genes_list.tsv', header = T, stringsAsFactors = F)
c1 <- dfm[dfm$Class == 'Class1', c('Gene', 'Experiment')]
  
dummy_df <- dummy.data.frame(c1, names=c('Experiment'), sep="_")
gene_freq <- aggregate(dummy_df[,-1], by=list(dummy_df$Gene), FUN=sum)
rownames(gene_freq) <- gene_freq$Group.1
gene_freq <- gene_freq[, -1]
colnames(gene_freq) <- sub('Experiment_', '', colnames(psite_freq))

write.table(gene_freq, 'tables/class1_genes_in_experiment.tsv', quote=F, sep='\t', col.names = NA)
gene_freq_sum <- table(rowSums(gene_freq))

pdf('figures/class1_genes_in_experiment_barplot.pdf')
barplot(gene_freq_sum, ylab='Number of Gene', xlab='Number of Experiment', ylim = c(0, max(gene_freq_sum)*1.1), col = col_set[2], border = NA)
dev.off()

