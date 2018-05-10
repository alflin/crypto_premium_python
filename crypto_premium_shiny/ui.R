library(shiny)
library(DT)
library(shinythemes)
library(shinydashboard)
library(shinyjs)

options(shiny.sanitize.errors = FALSE)

shinyUI( dashboardPage( 
  
  dashboardHeader(title = "Crypto Premium" ),
  dashboardSidebar(
           #actionButton("download", "Download New Data"),
           # actionButton("refresh", "Refresh All Values"),
           actionButton("dl_render","Download & Refresh"),
           actionButton("clearmsg", "clear msg"),
           textOutput('msg')
  ),
  dashboardBody(
    useShinyjs(),
    wellPanel(fluidRow( 
      valueBoxOutput("curr_1"),
      valueBoxOutput("curr_2"),
      valueBoxOutput("curr_3"),
      valueBoxOutput("next_1"),
      valueBoxOutput("next_2"),
      valueBoxOutput("next_3"),
      valueBoxOutput("quart_1"),
      valueBoxOutput("quart_2"),
      valueBoxOutput("quart_3")
    )),
    fluidRow( wellPanel(DT::dataTableOutput("prem_table"))
    )
  )
))


#### Define UI for application that draws a histogram
# shinyUI(
#   fluidPage(
#   
#   theme = shinytheme("cerulean"),
#   # Application title
#   titlePanel("Crypto Premium Charts"),
#   
#   # Sidebar with a slider input for number of bins 
#   fluidRow(
#     
#     wellPanel(
#        actionButton("action", "Download New Data"),
#        actionButton("action2", "Refresh Premium Table"),
#        actionButton("clearmsg", "clear msg"),
#        textOutput('msg')
#        )
#     ),
#     
#    # Show a plot of the generated distribution
#    wellPanel( 
#    fluidRow(
#       DT::dataTableOutput("prem_table")
#     ))
#   )
# )
