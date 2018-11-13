library(shiny)
library(DT)
library(shinydashboard)
library(rCharts)

dashboardPage(
  dashboardHeader(title = 'KSDB', titleWidth = 180),
  dashboardSidebar(
    width = 180,
    sidebarMenu(
      menuItem("Search Gene", tabName = "dashboard_1", icon = icon("th"))
    ),
    div(style = "padding-left: 15px; padding-top: 70px;",
        h4("Contact "),
        p(class="small"," "),
        p(class = "small","Xing Fu Ph.D. "),
        p(class = "small","xfu@sibs.ac.cn")
    )
  ),
  dashboardBody(
    # Also add some custom CSS to make the title background area the same
    # color as the rest of the header.
    tags$head(tags$style(HTML('
        .skin-blue .main-header .logo {
          background-color: #3c8dbc;
        }
        .skin-blue .main-header .logo:hover {
          background-color: #3c8dbc;
        }
      '))),
    tabItems(
      tabItem(tabName = 'dashboard_1',
        fluidRow(
          box(
            title = 'Search', status = 'primary', solidHeader = TRUE, collapsible = TRUE, width = 12,
            textInput(inputId = 'geneID',
                      label = 'Search TAIR geneID',
                      value = 'AT1G01050'
            ),
            actionButton("apply1", 'Apply')
          )
        ),
        fluidRow(
          box(
            title = 'Result', status = 'success', solidHeader = TRUE, collapsible = TRUE, width = 12,
            fluidRow(
              box(
                title = 'Phosphorylation sites', width = 12,
                DTOutput('tbl1')
              )
            ),
            fluidRow(
              box(
                title = 'Protein domains', width = 12, height = 400,
                imageOutput('img1')
              )
            ),
            fluidRow(
              box(
                title = 'Induced phosphorylation (in vitro)', width = 12,
                showOutput('chart1', lib='polycharts')
              ),
              box(
                title = 'Induced phosphorylation (in vivo)', width = 12,
                showOutput('chart2', lib='polycharts')
              )
            )
          )
        )
      ) 
    )
  )
)
