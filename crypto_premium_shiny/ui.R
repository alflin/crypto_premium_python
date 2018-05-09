library(shiny)
library(DT)

options(shiny.sanitize.errors = FALSE)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Crypto Premium Charts"),
  
  # Sidebar with a slider input for number of bins 
  fluidRow(
    wellPanel(
       actionButton("action", "Download New Data"),
       actionButton("action2", "Refresh Premium Table"),
       actionButton("clearmsg", "clear msg"),
       textOutput('msg')
       )
    ),
    
    # Show a plot of the generated distribution
    fluidRow(
      DT::dataTableOutput("prem_table")
    )
))
