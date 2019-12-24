library(dplyr)
library(drawProteins)
library(ggplot2)

db_name <- '/app/kinase' # run in docker
#db_name <- 'kinase' # run locally

my_db <- src_sqlite(db_name, create = FALSE)
phospho <- tbl(my_db, "phospho")
desc <- tbl(my_db, "desc")
domains <- tbl(my_db, "domains")

#' search data from the kinase dataset
#' @param id 
#' @get /gene
function(id){
  # Filter if the species was specified
  if (missing(id)){
    list(msg = "gene ID is not given")
  }
  else {
    dfm <- as.data.frame(filter(phospho, gene == toupper(id)) %>% left_join(desc))
    if(nrow(dfm) > 0) {
      dfm
    }
    else {
      list(msg = paste0(id, " is not found"))
    }
  }
}

#' draw protein and phospho sites
#' @param prot
#' @param sites
#' @png (800, 200)
#' @get /draw
function(prot, sites) {
  if (missing(prot)){
    list(msg = "protein ID is not given")
  }
  else if (missing(sites)){
    list(msg = "phospho sites is not given")
  }
  else {
    #data <- get_features(prot) %>% feature_to_dataframe() ## uniprot ID
    data <- filter(domains, accession == prot) %>% as.data.frame() ## TAIR ID
    aa <- as.numeric(strsplit(sites, ',')[[1]])
    psite <- data.frame(type='MOD_RES',
                        description='Phospho',
                        begin=aa,
                        end=aa,
                        length=0,
                        accession=data$accession[1],
                        entryName=data$entryName[1],
                        taxid=data$taxid[1],
                        order=data$order[1])
    data <- rbind(data, psite)
    p <- draw_canvas(data)
    p <- draw_canvas(data) %>% draw_chains(data) %>% draw_domains(data) %>% draw_phospho(data, size = 4)
    p <- p + theme_bw(base_size = 20) + # white backgnd & change text size
      theme(panel.grid.minor=element_blank(),
            panel.grid.major=element_blank()) +
      theme(axis.ticks = element_blank(),
            axis.text.y = element_blank()) +
      theme(panel.border = element_blank())
    print(p)
  }
}


