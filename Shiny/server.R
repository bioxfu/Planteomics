library(shiny)
library(jsonlite)
library(DT)
library(rCharts)
library(dplyr)
`%then%` <- shiny:::`%OR%`

shinyServer(function(input, output){
  api_host <- 'http://10.41.9.210:8080'
  passData1 <- eventReactive(input$apply1, {
    geneID <- input$geneID
    dfm <- fromJSON(paste0(api_host, "/gene?id=", geneID))[1:9]
    shiny::validate(
      need(geneID, 'Please input TAIR geneID') %then%
      need(is.null(dfm$msg), 'No result has been found')
    )
    list(dfm=dfm)
  })
  
  output$tbl1 <- renderDT({
    tbl <- passData1()$dfm[c('site', 'aa', 'window', 'experiment')]
    tbl$experiment <- sub('_.+', '', tbl$experiment)
    tbl <- unique(tbl) %>% group_by(site, aa, window) %>% summarise(kinase=toString(experiment)) %>% ungroup()
    colnames(tbl) <- c('Phosphorylation sites', 'Amino acid', 'Sequence window', 'Kinase')
    rownames(tbl) <- NULL
    tbl
  })
  
  output$img1 <- renderImage({
    prot <- unique(passData1()$dfm$protein)
    sites <- paste0(unique(passData1()$dfm$site), collapse = ',')

    # A temp file to save the output.
    # This file will be automatically removed later by
    # renderImage, because of the deleteFile=TRUE argument.
    outfile <- tempfile(fileext = ".png")
    url <- paste0(api_host, "/draw?prot=", prot, '&sites=', sites)
    download.file(url, destfile = outfile)
    
    # Return a list containing information about the image
    list(src = outfile,
         contentType = "image/png",
         style='width:100%',
         alt = "This is alternate text")
  }, deleteFile = TRUE)
  
  output$chart1 <- renderChart2({
    dfm <- passData1()$dfm
    dfm <- dfm[dfm$class == 'vitro' & dfm$diff != 0, c('site', 'experiment', 'class', 'diff')]
    #print(dfm)
    p1 <- rPlot(diff ~ experiment | site, data=dfm, type='bar', color='experiment')
    p1$set(width = 800, height = 400)
    p1$guides(y = list(title = 'Treatment - Mock'))
    p1$guides(x = list(title = 'Experiment (in vitro)'))
    return(p1)
  })
  
  output$chart2 <- renderChart2({
    dfm <- passData1()$dfm
    dfm <- dfm[dfm$class == 'vivo' & dfm$diff != 0, c('site', 'experiment', 'class', 'diff')]
    #print(dfm)
    p1 <- rPlot(diff ~ experiment | site, data=dfm, type='bar', color='experiment')
    p1$set(width = 800, height = 400)
    p1$guides(y = list(title = 'Treatment - Mock'))
    p1$guides(x = list(title = 'Experiment (in vivo)'))
    return(p1)
  })
  
})
