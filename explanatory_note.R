#explanatory text accompanying the financial flows graph
expl<-paste("The data shown reflects quarterly net transactions. Valuation effects are not captured. Data is not seasonally adjusted.", 
            "Blue lines go from financier to asset, green lines from asset to recipient of the funding. Arrows point in the direction of net flows for the given quarter. Line width is scaled to the size of the respective net flow.",
            "Sizes of the circles are not scaled to balance sheet size.",
            "Individual nodes can be highlighted by clicking on them.",
            "All data in billions of Euros.",
            "It is important to note that this network is not a closed system as inflows from non Euro Area counterparties and outflows to the former are not captured.",sep="\n")
defs<-paste("Banks: Monetary financial institutions",
"Government: Central and subnational government bodies",
"Non-banks: Non monetary financial institutions, including investment funds, financial vehicle corporations, insurance corporations and pension funds",
"Households: Households and non profit institutions serving households",
"Bonds: Debt securities of all maturities",
"Equities: Listed and unlisted shares as well as other equity; excludes investment fund shares",
"Loans: Fixed debt contracts between borrowers and lenders, including mortgages and loans for consumption",
"IF Shares: Investment fund shares",
"Flows from the Central Bank are defined as net purchases under the ECB's Asset Purchase Programmes, including the Corporate Sector Purchase Programme, the Public Sector Purchase Programme,the Asset Backed Securities Purchase Programme and the Third Covered Bond Purchase Programme", sep="\n")

#hyperlinks
urlECBstats<-a("ECB Data Warehouse", href="http://sdw.ecb.europa.eu/")
urlESA2010<-a("ESA 2010 Accounts", href="http://ec.europa.eu/eurostat/cache/metadata/Annexes/nasa_10_f_esms_an1.pdf")




