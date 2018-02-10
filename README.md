# FinancialFlowsEuroArea
Shiny app showing quarterly net financial flows in the Euro Area financial system 2013-2017

The script euro_data_input_Q produces the datafiles and shows all ECB SDW codes for the inputs to the visual. 
Running this is only necessary to update the data.

The balance sheet file contains data on the ECB's APP which had to be downloaded manually from the webiste.

The animation is run as Shiny App which can be done locally, for instance in R-Studio by navigating to the root directory of the ui and server file and running runApp().
For detailed instructions, see: https://shiny.rstudio.com/articles/running.html
