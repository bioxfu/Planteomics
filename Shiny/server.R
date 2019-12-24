library(shiny)
library(jsonlite)
library(DT)
library(rCharts)
library(dplyr)
`%then%` <- shiny:::`%OR%`

shinyServer(function(input, output){
  api_host <- fromJSON('config.json')$api_host
  passData1 <- eventReactive(input$apply1, {
    geneID <- input$geneID
    dfm <- fromJSON(paste0(api_host, "/gene?id=", geneID))[1:12]
    shiny::validate(
      need(geneID, 'Please input TAIR geneID') %then%
      need(is.null(dfm$msg), 'No result has been found')
    )
    list(dfm=dfm)
  })
  
  output$text1 <- renderText({
    des <- unique(passData1()$dfm[,'description'])
    prot <- unique(passData1()$dfm[,'protein'])
    paste(des, '(', prot, ')')
  })
  
  output$tbl1 <- renderDT({
    dfm <- passData1()$dfm
    tbl_1 <- dfm[c('site', 'aa', 'window', 'experiment')]
    tbl_2 <- dfm[c('site', 'aa', 'window', 'class')]
    tbl_2$class[tbl_2$class=='I' | tbl_2$class=='unclassified'] <- ''
    tbl_2$kinase <- paste(sub('_.+', '', tbl_1$experiment), '(', tbl_2$class, ')')
    tbl_2$kinase[tbl_2$class==''] <- ''
    tbl_1 <- unique(tbl_1) %>% group_by(site, aa, window) %>% summarise(experiment2=toString(experiment)) %>% ungroup()
    tbl_2 <- unique(tbl_2) %>% group_by(site, aa, window) %>% summarise(kinase2=toString(kinase)) %>% ungroup()
    tbl_2$kinase2 <- sub('^,', '', tbl_2$kinase2)
    tbl <- merge(tbl_1, tbl_2, by.x=1, by.y=1)[c(1:4,7)]
    colnames(tbl) <- c('Phosphosites', 'Amino acid', 'Sequence window', 'Experiment', 'Kinase')
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
    dfm <- dfm[dfm$type == 'vitro' & dfm$diff != 0, c('site', 'experiment', 'type', 'diff')]
    #print(dfm)
    p1 <- rPlot(diff ~ experiment | site, data=dfm, type='bar', color='experiment')
    p1$set(width = 800, height = 400)
    p1$guides(y = list(title = 'log2 Ratio'),
              x = list(title = 'Experiment (in vitro)', ticks=''))
    return(p1)
  })
  
  output$chart2 <- renderChart2({
    dfm <- passData1()$dfm
    dfm <- dfm[dfm$type == 'vivo' & dfm$diff != 0, c('site', 'experiment', 'type', 'diff')]
    #print(dfm)
    p1 <- rPlot(diff ~ experiment | site, data=dfm, type='bar', color='experiment')
    p1$set(width = 800, height = 400)
    p1$guides(y = list(title = 'log2 Ratio'),
              x = list(title = 'Experiment (in vivo)', ticks=''))
    return(p1)
  })
  
})
