library(shiny)
library(reticulate)
library(readr)
library(DT)

options(shiny.sanitize.errors = FALSE)
#production setwd
#setwd('/srv/shiny-server/crypto_premium_python/crypto_premium_shiny')
# prem.df <- read_csv('premiums.csv')

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  #download new data
  observeEvent(input$action, {
    withProgress(message = 'Downloading new Data', value = 0, {
      print(getwd())
      use_virtualenv('./venv', required = TRUE)
      #use_virtualenv('/srv/shiny-server/crypto_premium_python/crypto_premium_shiny/venv', required = TRUE)
      print('virtualenvdone')
      py_run_file("okex-shiny.py")
    })
  })
  
  #Update Chart
  observeEvent(input$action2, {
    prem.df <- reactive({read_csv('premiums.csv')})

    output$prem_table = DT::renderDataTable(
      prem.df(), filter = 'top', options = list(pageLength = 24)
    )
  })

  
  #Reads first time around
  prem.df <- reactive({read_csv('premiums.csv')})
  
  #Renders the table first time around
  output$prem_table = DT::renderDataTable(
    prem.df(), filter = 'top', options = list(pageLength = 24)
  )
  
})
