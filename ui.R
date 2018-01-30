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
#source('settings.R')

#var vals=['2007-Q1','2007-Q2','2007-Q3','2007-Q4','2008-Q1','2008-Q2','2008-Q3','2008-Q4','2009-Q1','2009-Q2','2009-Q3','2009-Q4','2010-Q1','2010-Q2','2010-Q3','2010-Q4',
#          '2011-Q1','2011-Q2','2011-Q3','2011-Q4','2012-Q1','2012-Q2','2012-Q3','2012-Q4','2013-Q1','2013-Q2','2013-Q3',
#          '2013-Q4','2014-Q1','2014-Q2','2014-Q3','2014-Q4','2015-Q1','2015-Q2','2015-Q3','2015-Q4','2016-Q1','2016-Q2','2016-Q3','2016-Q4','2017-Q1'];

#custom slider
JScode <-
  "$(function() {
setTimeout(function(){
var vals=['13-Q1','13-Q2','13-Q3','13-Q4','14-Q1','14-Q2','14-Q3','14-Q4','15-Q1','15-Q2','15-Q3','15-Q4','16-Q1','16-Q2','16-Q3','16-Q4','17-Q1'];
for (i = 0; i >= vals.length; i++) {
var val = (0,17);
vals.push(val);
}
$('#quarter').data('ionRangeSlider').update({'values':vals})
}, 13)})"


#button<-actionButton(inputId= "RunFullModel", label ="this", 
 #            style = "color: white; 
  #                     background-color: #35e51d; 
   #                    position: relative; 
    #                   left: 3%;
     #                  height: 35px;
      #                 width: 35px;
       #                text-align:center;
        #               text-indent: -2px;
         #              border-radius: 6px;
          #             border-width: 2px"))

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
    style="min-width:100px;max-width:450px",
    sliderInput("animation", "Looping Animation:", inputId="quarter",label="Quarter:",min=0,max=17, value=0, step = 1, 
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
  div(class="set1",tabPanel("Flow",visNetworkOutput("net",width="1200px",height="900px")))
  #div(class="set1",
  #tabsetPanel(tabPanel("Flow",visNetworkOutput("net",width="1000px",height="700px")))
  #    visNetworkOutput("net")
   # tags$style(type="text/css","#net{height:calc(100vh-10px);}"),
  #  visNetworkOutput("net")
  #))
))))

