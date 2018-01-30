#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(visNetwork)
#source("finflows.R")
source("finflows2.R")
source("explanatory_note.R")

# Define server logic required to generate and plot a random distribution
shinyServer(function(input, output,session) {
  output$explanatory_note <- renderText({
    paste(expl)
  })
  output$definitions <- renderText({
    paste(defs)
  })
  output$ecb<-renderUI({
    tagList("Data: ",urlECBstats)
  })
  output$esa<-renderUI({
    tagList("Reference guide definitions:",urlESA2010)
  })
  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #

  output$net <- renderVisNetwork({
    net[[input$quarter+1]]
  })
})