library(shiny)
library(rPython)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Old Faithful Geyser Data"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("bins",
                   "Number of bins:",
                   min = 1,
                   max = 50,
                   value = 30),
       actionButton("action", "Execute!"),
       actionButton("action2", "Execute2!")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       
       #new stuff
       sliderInput('x', 'Set x', 0, 10, 5),
       verbatimTextOutput('out1')
       
    )
  )
))
