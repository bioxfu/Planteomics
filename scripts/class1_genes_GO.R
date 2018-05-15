library(GO.db)
source('scripts/topGO.R')

dfm <- read.table('tables/class1-3_genes_list.tsv', header = T, stringsAsFactors = F)
dfm <- dfm[dfm$Class == 'Class1', c('Experiment', 'Gene')]
gene_lst <- split(dfm['Gene'], dfm$Experiment)

go_lst <- list()
for (i in 1:length(gene_lst)) {
  go <- topGO(gene_lst[[i]]$Gene)
  go$Term <- apply(go, 1, function(x){Term(GOTERM[[x[1]]])})
  go_lst[[i]] <- go
}
names(go_lst) <- names(gene_lst)

save(list=c('go_lst'), file='RData/class1_genes_GO.RData')
