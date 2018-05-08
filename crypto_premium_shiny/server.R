library(shiny)
library(rPython)
library(reticulate)



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2] 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
  })
  
  output$out1 <- renderPrint({
    python.call("len", 1:input$x)
  })
  
  observeEvent(input$action, {
    print('fuckthis')
    
    use_virtualenv('/Users/zhouyuan/Desktop/crypto_premium/crypto_premium_shiny/venv', required = TRUE)
    print(py_discover_config())
    py_run_file("okex-shiny.py")
    print('didnt crash?')
    
  })
  
  observeEvent(input$action2, {
    print('fuckthis2')
    print(py_discover_config())
    source_python('okex-shiny.py')
    print('didnt crash?')
    
  })
  
  
  
  
})
