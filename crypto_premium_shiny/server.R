library(shiny)
library(reticulate)
library(readr)

# prem.df <- read_csv('premiums.csv')

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  #download new data
  observeEvent(input$action, {
    withProgress(message = 'Downloading new Data', value = 0, {
      #use_virtualenv('/Users/zhouyuan/Desktop/crypto_premium/crypto_premium_shiny/venv', required = TRUE)
      use_virtualenv('./venv', required = TRUE)
      #print(py_discover_config())
      py_run_file("okex-shiny.py")
    })
  })
  
  #Update Chart
  observeEvent(input$action2, {
    prem.df <- reactive({read_csv('premiums.csv')})

    output$prem_table = renderDT(
      prem.df(), filter = 'top', options = list(pageLength = 24)
    )
  })

  
  #Reads first time around
  prem.df <- reactive({read_csv('premiums.csv')})
  
  #Renders the table first time around
  output$prem_table = renderDT(
    prem.df(), filter = 'top', options = list(pageLength = 24)
  )
  
})
