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

## GO analysis of proteins which could serve as direct targets of multiple (4，5，6，7，8，9) protein kinases
library(GO.db)
source('scripts/topGO.R')

gene_lst <- list(four  = rownames(gene_freq)[(rowSums(gene_freq) == 4)],
                 five  = rownames(gene_freq)[(rowSums(gene_freq) == 5)],
                 six   = rownames(gene_freq)[(rowSums(gene_freq) == 6)],
                 seven = rownames(gene_freq)[(rowSums(gene_freq) == 7)],
                 eight = rownames(gene_freq)[(rowSums(gene_freq) == 8)],
                 nine  = rownames(gene_freq)[(rowSums(gene_freq) == 9)])
                 

go_lst <- list()
for (i in 1:length(gene_lst)) {
  go <- topGO(gene_lst[[i]])
  go$Term <- apply(go, 1, function(x){Term(GOTERM[[x[1]]])})
  go_lst[[i]] <- go
}
names(go_lst) <- names(gene_lst)

library(xlsx)

wb <- createWorkbook()
for (i in 1:length(go_lst)) {
  sheet <- createSheet(wb, sheetName=names(go_lst[i]))
  addDataFrame(go_lst[[i]], sheet, row.names = FALSE)
}
saveWorkbook(wb, "tables/class1_genes_in_experiment_barplot_GO_Excel.xlsx")
