library(pheatmap)
library(RColorBrewer)
library(magrittr)

load('RData/class1_genes_GO.RData')

go_lst_filt <- lapply(go_lst, function(x){x[x$pvalue<0.0001,]})
#go_lst_filt <- lapply(go_lst, function(x){x[x$pvalue<0.000001,]})

all_term <- do.call(rbind, go_lst_filt)$Term %>% unique()

all_mat <- matrix(nrow=length(all_term), ncol=length(go_lst_filt), dimnames=list(all_term, names(go_lst)))

for (i in 1:length(go_lst_filt)) {
  all_mat[go_lst_filt[[i]]$Term, i] <- -log10(go_lst_filt[[i]]$pvalue)
}

all_mat[is.na(all_mat)] <- 4
#all_mat[is.na(all_mat)] <- 6
all_mat[all_mat > 10] <- 10

pdf('figures/class1_genes_GO_heatmap.pdf', hei=17)
pheatmap(all_mat, cluster_cols = T, cluster_rows = T, col=rev(colorRampPalette(rev(brewer.pal(n=7, name="Blues")))(100)), legend_breaks=c(4.1,6,8,10), legend_labels = c('<4','6','8','>10'))
#pheatmap(all_mat, cluster_cols = T, cluster_rows = T, col=rev(colorRampPalette(rev(brewer.pal(n=7, name="Blues")))(100)), legend_breaks=c(6.1,8,10), legend_labels = c('6','8','>10'))
dev.off()
system('./scripts/pheatmap_pdf_cleaner.sh figures class1_genes_GO_heatmap.pdf')
