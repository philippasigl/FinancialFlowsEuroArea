# FinancialFlowsEuroArea

Shiny app showing quarterly net financial flows in the Euro Area financial system 2007-2017.

Running the app locally requires:
1) Run ecb_data_input_Q.R to create edge and node files
2) Run the shiny app from the ui file

The data on the ECB's asset purchases comes from static csv files (pulled from the ECB website), all other data comes from the ECB data warehouse and can easily be updated by calling the relevant script.
