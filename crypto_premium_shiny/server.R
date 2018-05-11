library(shiny)
library(reticulate)
library(readr)
library(DT)
library(shinydashboard)
library(shinyjs)
library(dplyr)

options(shiny.sanitize.errors = FALSE)

#production setwd
if (Sys.info()[["nodename"]] == "shiny-02"){
  setwd('/srv/shiny-server/cyp/crypto_premium_shiny')  
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  autoInvalidate <- reactiveTimer(5000)
  
  # First Actions  --------------------------------------------------------------
  #autohide sidebar
  addClass(selector = "body", class = "sidebar-collapse")
  
  #testing
  invalidater <- reactiveValues( v = 0)
  
  #Read file, re-checks every 5 seconds
  prem.df <- reactive({
    # autoInvalidate() 
    invalidater$v
    return(suppressMessages(read_csv('premiums.csv')))
    })
  
  #leaderboard values
  top3 <- reactive({
    prem.df() %>% group_by(fdate) %>% top_n(3,premium) %>% select(spot_ticker, premium, daysleft, fdate) %>% arrange(fdate)
    })
  
  
  # Output Renderers  --------------------------------------------------------------
  output$prem_table = DT::renderDataTable(
    prem.df(), filter = 'top', options = list(pageLength = 24, searching = FALSE)
  )
  
  output$curr_1 <- renderValueBox({
    valueBox(
      paste('#1',unlist(top3()[7,1])), 
      paste( unlist(top3()[7,3]), ' days for ',paste0( round(100*unlist(top3()[7,2]),2) , "% - Current")),
      icon = icon("list"),
      color = "blue"
    )})
  output$curr_2 <- renderValueBox({
    valueBox(
      paste('#2',unlist(top3()[8,1])), 
      paste( unlist(top3()[8,3]), ' days for ',paste0( round(100*unlist(top3()[8,2]),2) , "% - Current")),
      icon = icon("list"),
      color = "blue"
    )})
  output$curr_3 <- renderValueBox({
    valueBox(
      paste('#3',unlist(top3()[9,1])), 
      paste( unlist(top3()[9,3]), ' days for ',paste0( round(100*unlist(top3()[9,2]),2) , "% - Current")),
      icon = icon("list"),
      color = "blue"
    )})
  
  output$next_1 <- renderValueBox({
    valueBox(
      paste('#1',unlist(top3()[1,1])), 
      paste( unlist(top3()[1,3]), ' days for ',paste0( round(100*unlist(top3()[1,2]),2) , "% - Next")),
      icon = icon("list"),
      color = "green"
    )})
  output$next_2 <- renderValueBox({
    valueBox(
      paste('#2',unlist(top3()[2,1])), 
      paste( unlist(top3()[2,3]), ' days for ',paste0( round(100*unlist(top3()[2,2]),2) , "% - Next")),
      icon = icon("list"),
      color = "green"
    )})
  output$next_3 <- renderValueBox({
    valueBox(
      paste('#3',unlist(top3()[3,1])), 
      paste( unlist(top3()[3,3]), ' days for ',paste0( round(100*unlist(top3()[3,2]),2) , "% - Next")),
      icon = icon("list"),
      color = "green"
    )})
  
  output$quart_1 <- renderValueBox({
    valueBox(
      paste('#1',unlist(top3()[4,1])), 
      paste( unlist(top3()[4,3]), ' days for ',paste0( round(100*unlist(top3()[4,2]),2) , "% - Quarterly")),
      icon = icon("list"),
      color = "purple"
    )})
  output$quart_2 <- renderValueBox({
    valueBox(
      paste('#2',unlist(top3()[5,1])), 
      paste( unlist(top3()[5,3]), ' days for ',paste0( round(100*unlist(top3()[5,2]),2) , "% - Quarterly")),
      icon = icon("list"),
      color = "purple"
    )})
  output$quart_3 <- renderValueBox({
    valueBox(
      paste('#3',unlist(top3()[6,1])), 
      paste( unlist(top3()[6,3]), ' days for ',paste0( round(100*unlist(top3()[6,2]),2) , "% - Quarterly")),
      icon = icon("list"),
      color = "purple"
    )})

  
  # Button Logic --------------------------------------------------------------
  
  #download new data
  observeEvent(input$download, {
    withProgress(message = 'Downloading new Data', value = 0, {
      
      use_virtualenv('./venv', required = TRUE)
      
      okex <- import_from_path('okex', path = ".", convert = TRUE)
      okex$csv_update_current()
      
      output$msg <- renderText({"finished downloading"})
      
      invalidater$v <- invalidater$v + 1
      
    })
  })  
  
})
