#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(visNetwork)

#custom slider
JScode <-
  "$(function() {
setTimeout(function(){
var vals=['07-Q1','07-Q2','07-Q3','07-Q4','08-Q1','08-Q2','08-Q3','08-Q4','09-Q1','09-Q2','09-Q3','09-Q4','10-Q1','10-Q2','10-Q3','10-Q4',
'11-Q1','11-Q2','11-Q3','11-Q4','12-Q1','12-Q2','12-Q3','12-Q4','13-Q1','13-Q2','13-Q3',
'13-Q4','14-Q1','14-Q2','14-Q3','14-Q4','15-Q1','15-Q2','15-Q3','15-Q4','16-Q1','16-Q2','16-Q3','16-Q4','17-Q1'];
for (i = 0; i >= vals.length; i++) {
var val = (0,13);
vals.push(val);
}
$('#quarter').data('ionRangeSlider').update({'values':vals})
}, 13)})"

#main UI
shinyUI(fluidPage(
  includeCSS("style.css"),
  # Application title
  headerPanel("Financial Flows Euro Area"),
  # Sidebar with a slider input for number of observations
  sidebarLayout(
  div(class="set1",
  sidebarPanel(
    tags$head(tags$script(HTML(JScode))),
    #tags$head(tags$script(src="slider.js")),
    div(class="set0",(actionButton(inputId="QE_label",label="QE begins",style="font-size: 10px; padding: 2px; border: 0; background: #66e575; color: white;"))),
    style="min-width:100px;max-width:400px",
    sliderInput("animation", "Looping Animation:", inputId="quarter",label="Quarter:",min=0,max=13, value=0, step = 1, 
                animate=animationOptions(interval=1600, loop=T)),
    HTML('<br/>'),
    h4("Explanatory notes"),
    verbatimTextOutput("explanatory_note"),
    h4("Definitions"),
    verbatimTextOutput("definitions"),
    uiOutput("ecb"),
    uiOutput("esa")
  #  p(paste("Detailed definitions can be found here: ", tagList(urlESA2010)))
  )),
  # Show a plot of the generated distribution
  mainPanel(
  div(class="set1",
  tabsetPanel(tabPanel("Flow",visNetworkOutput("net",width="1000px",height="800px")))
  #    visNetworkOutput("net")
   # tags$style(type="text/css","#net{height:calc(100vh-10px);}"),
  #  visNetworkOutput("net")
  ))
)))

