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
  setwd('/srv/shiny-server/crypto_premium_python/crypto_premium_shiny')  
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  
  # Helper Functions  --------------------------------------------------------------
  #function for rendering premtable
  rend_premtable <- function(){
    output$prem_table = DT::renderDataTable(
      prem.df, filter = 'top', options = list(pageLength = 24, searching = FALSE)
    )
  }
  
  #renders all valueboxes
  rend_valuebox <- function() {
    
    output$curr_1 <- renderValueBox({
      valueBox(
        paste('#1',unlist(top3[7,1])), 
        paste( unlist(top3[7,3]), ' days for ',paste0( round(100*unlist(top3[7,2]),2) , "% - Current")),
        icon = icon("list"),
        color = "blue"
      )})
    output$curr_2 <- renderValueBox({
      valueBox(
        paste('#2',unlist(top3[8,1])), 
        paste( unlist(top3[8,3]), ' days for ',paste0( round(100*unlist(top3[8,2]),2) , "% - Current")),
        icon = icon("list"),
        color = "blue"
      )})
    output$curr_3 <- renderValueBox({
      valueBox(
        paste('#3',unlist(top3[9,1])), 
        paste( unlist(top3[9,3]), ' days for ',paste0( round(100*unlist(top3[9,2]),2) , "% - Current")),
        icon = icon("list"),
        color = "blue"
      )})
    
    output$next_1 <- renderValueBox({
      valueBox(
        paste('#1',unlist(top3[1,1])), 
        paste( unlist(top3[1,3]), ' days for ',paste0( round(100*unlist(top3[1,2]),2) , "% - Next")),
        icon = icon("list"),
        color = "green"
      )})
    output$next_2 <- renderValueBox({
      valueBox(
        paste('#2',unlist(top3[2,1])), 
        paste( unlist(top3[2,3]), ' days for ',paste0( round(100*unlist(top3[2,2]),2) , "% - Next")),
        icon = icon("list"),
        color = "green"
      )})
    output$next_3 <- renderValueBox({
      valueBox(
        paste('#3',unlist(top3[3,1])), 
        paste( unlist(top3[3,3]), ' days for ',paste0( round(100*unlist(top3[3,2]),2) , "% - Next")),
        icon = icon("list"),
        color = "green"
      )})
    
    output$quart_1 <- renderValueBox({
      valueBox(
        paste('#1',unlist(top3[4,1])), 
        paste( unlist(top3[4,3]), ' days for ',paste0( round(100*unlist(top3[4,2]),2) , "% - Quarterly")),
        icon = icon("list"),
        color = "purple"
      )})
    output$quart_2 <- renderValueBox({
      valueBox(
        paste('#2',unlist(top3[5,1])), 
        paste( unlist(top3[5,3]), ' days for ',paste0( round(100*unlist(top3[5,2]),2) , "% - Quarterly")),
        icon = icon("list"),
        color = "purple"
      )})
    output$quart_3 <- renderValueBox({
      valueBox(
        paste('#3',unlist(top3[6,1])), 
        paste( unlist(top3[6,3]), ' days for ',paste0( round(100*unlist(top3[6,2]),2) , "% - Quarterly")),
        icon = icon("list"),
        color = "purple"
      )})
  }
  
  #function for updating values
  update_values <- function(){
    prem.df <- read_csv('premiums.csv')
    top3 <- prem.df %>% group_by(fdate) %>% top_n(3,premium) %>% select(spot_ticker, premium, daysleft, fdate) %>% arrange(fdate)
  }
  
  # First Actions  --------------------------------------------------------------
  #autohide sidebar
  addClass(selector = "body", class = "sidebar-collapse")
  
  #Reads first time around
  update_values()
  rend_premtable()
  rend_valuebox()
  
  
  # Button Logic --------------------------------------------------------------
  #clear msg Button 
  observeEvent(input$clearmsg, {output$msg <- renderText({'cleared'})})
  
  #download new data
  observeEvent(input$download, {
    withProgress(message = 'Downloading new Data', value = 0, {
      use_virtualenv('./venv', required = TRUE)
      
      okex <- import_from_path('okex', path = ".", convert = TRUE)
      okex$csv_update_current()
      
      output$msg <- renderText({"finished downloading"})
    })
  })
  
  #Refresh all Values
  observeEvent(input$refresh, {
    output$msg <- renderText({'updating table'})
    update_values()
    rend_premtable()
    rend_valuebox()
  })
  
  #download new data & re-render
  observeEvent(input$dl_render, {
    withProgress(message = 'Downloading new Data', value = 0, {
      use_virtualenv('./venv', required = TRUE)
      
      okex <- import_from_path('okex', path = ".", convert = TRUE)
      okex$csv_update_current()
      
      update_values()
      rend_premtable()
      rend_valuebox()
      
      output$msg <- renderText({'downloaded & updated'})

  })})
  
  # Other Code  --------------------------------------------------------------
  
  
})
