library(xlsx)

load('RData/class1_genes_GO.RData')

wb <- createWorkbook()
for (i in 1:length(go_lst)) {
  sheet <- createSheet(wb, sheetName=names(go_lst[i]))
  addDataFrame(go_lst[[i]], sheet, row.names = FALSE)
}
saveWorkbook(wb, "tables/class1_genes_GO_Excel.xlsx")
