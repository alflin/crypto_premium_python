library(shiny)
library(reticulate)
library(readr)
library(DT)

options(shiny.sanitize.errors = FALSE)

#production setwd
if (Sys.info()[["nodename"]] == "shiny-02"){
  setwd('/srv/shiny-server/crypto_premium_python/crypto_premium_shiny')  
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  #download new data
  observeEvent(input$action, {
    withProgress(message = 'Downloading new Data', value = 0, {
      use_virtualenv('./venv', required = TRUE)
      
      okex <- import_from_path('okex', path = ".", convert = TRUE)
      okex$csv_update_current()
      
      output$msg <- renderText({"finished downloading"})
    })
  })
  
  #Update Chart
  observeEvent(input$action2, {
    output$msg <- renderText({'updating table'})
    prem.df <- reactive({read_csv('premiums.csv')})

    output$prem_table = DT::renderDataTable(
      prem.df(), filter = 'top', options = list(pageLength = 24, searching = FALSE)
    )
  })
  
  #clear msg Button 
  observeEvent(input$clearmsg, {output$msg <- renderText({'cleared'})})

  #Reads first time around
  prem.df <- reactive({read_csv('premiums.csv')})
  
  #Renders the table first time around
  output$prem_table = DT::renderDataTable(
    prem.df(), filter = 'top', options = list(pageLength = 24, searching = FALSE)
  )
  
})
