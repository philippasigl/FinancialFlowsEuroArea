library(ecb)
library(plyr)
library(pdfetch)

###-----------------------------------------------------------------------------------------------------------###
###info###

##timeline
#2007-2017 
#(limited by investment fund data availability)

##ids
#mfi: 1
#other financial institutions: 3
#corporates: 4
#gov't: 2
#cb: 0
#hhs: 6
#debt securities: 7
#equities: 8
#deposits and currency: 9
#other assets/liabilities: 10
#loans: 11
#real economy: 12

###-----------------------------------------------------------------------------------------------------------###
###definitions###
mfi<-"BANKS"
iv<-"INVESTMENT FUNDS"
ipf<-"INSURANCE AND PENSION FUNDS"
govt<-"GOVERNMENT"
nfc<-"NON-FINANCIAL COMPANIES"
hh<-"HOUSEHOLDS"
cb<-"ECB"
debt_sec<-"BONDS"
equities<-"EQUITIES"
dep_and_cur<-"DEPOSITS AND CURRENCY"
loans<-"LOANS"
cons<-"HOUSEHOLD SPENDING"
iv<-"IF SHARES"
total<-"TOTAL"
other<-"OTHER"
re<-"NET INVESTMENTS"
income<-"INCOME"
ofi<-"NON-BANKS"
###-----------------------------------------------------------------------------------------------------------###
startPeriod<-"2013"
endPeriod<-"2017"
lastQuarter<-"1"
instr_dummy<-1000000

###1.mfis - aggregated
##debt securities
#st
mfi_debt_sec_st<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.F.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_debt_sec_st<-data.frame(mfi_debt_sec_st)
mfi_debt_sec_st<-data.frame("id_holder"=1,"party"=mfi,"id_rec"=7,"instrument"=debt_sec,"time"=mfi_debt_sec_st$obstime,
                         "value"=mfi_debt_sec_st$obsvalue,"type"=1,"flow"=mfi_debt_sec_st$obsvalue)
#lt
mfi_debt_sec_lt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.F.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_debt_sec_lt<-data.frame(mfi_debt_sec_lt)
mfi_debt_sec_lt<-data.frame("id_holder"=1,"party"=mfi,"id_rec"=7,"instrument"=debt_sec,"time"=mfi_debt_sec_lt$obstime,
                         "value"=mfi_debt_sec_lt$obsvalue,"type"=1,"flow"=mfi_debt_sec_lt$obsvalue)

mfi_debt_sec<-mfi_debt_sec_st
mfi_debt_sec$flow<-mfi_debt_sec_st$flow+mfi_debt_sec_lt$flow

##equities and investment fund shares
mfi_listed_shares<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_listed_shares<-data.frame(mfi_listed_shares)
mfi_listed_shares<-data.frame("id_holder"=1,"party"=mfi,"id_rec"=8,"instrument"=equities,"time"=mfi_listed_shares$obstime,
                         "value"=mfi_listed_shares$obsvalue,"type"=1,"flow"=mfi_listed_shares$obsvalue)
mfi_iv_shares<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.F.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_iv_shares<-data.frame(mfi_iv_shares)
mfi_iv_shares<-data.frame("id_holder"=1,"party"=mfi,"id_rec"=14,"instrument"=iv,"time"=mfi_iv_shares$obstime,
                              "value"=mfi_iv_shares$obsvalue,"type"=1,"flow"=mfi_iv_shares$obsvalue)
mfi_unlisted_shares<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_unlisted_shares<-data.frame(mfi_unlisted_shares)
mfi_unlisted_shares<-data.frame("id_holder"=1,"party"=mfi,"id_rec"=8,"instrument"=equities,"time"=mfi_unlisted_shares$obstime,
                          "value"=mfi_unlisted_shares$obsvalue,"type"=1,"flow"=mfi_unlisted_shares$obsvalue)
mfi_equities<-mfi_listed_shares
mfi_equities$flow<-mfi_listed_shares$flow+mfi_unlisted_shares$flow

##loans lt
mfi_loans_lt<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.F.F4.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_loans_lt<-data.frame(mfi_loans_lt)
mfi_loans_lt<-data.frame("id_holder"=1,"party"=mfi,"id_rec"=11,"instrument"=loans,"time"=mfi_loans_lt$obstime,
                      "value"=mfi_loans_lt$obsvalue,"type"=1,"flow"=mfi_loans_lt$obsvalue)
mfi_loans_st<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.F.F4.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_loans_st<-data.frame(mfi_loans_st)
mfi_loans_st<-data.frame("id_holder"=1,"party"=mfi,"id_rec"=11,"instrument"=loans,"time"=mfi_loans_st$obstime,
                         "value"=mfi_loans_st$obsvalue,"type"=1,"flow"=mfi_loans_st$obsvalue)
mfi_loans<-mfi_loans_lt
mfi_loans$flow<-mfi_loans_lt$flow+mfi_loans_st$flow

##total balance sheet
#NOT USED FOR SCALING
mfi_bs<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.A.LE.F._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
mfi_bs<-data.frame(mfi_bs)
mfi_bs<-data.frame("id_holder"=1,"party"=mfi,"instrument"=total,"time"=mfi_bs$obstime,"value"=mfi_bs$obsvalue,"type"=1)

###2. other financial institutions
#ofi + investment funds + insurance and pension funds
##loans
iv_loans<-get_data("QSA.Q.N.I8.W0.S124.S1.N.A.F.F4.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_loans<-data.frame(iv_loans)
iv_loans<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=11,"instrument"=loans,"time"=iv_loans$obstime,
                     "value"=iv_loans$obsvalue,"type"=1,"flow"=iv_loans$obsvalue)

ofi_loans<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.A.F.F4.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
ofi_loans<-data.frame(ofi_loans)
ofi_loans<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=11,"instrument"=loans,"time"=ofi_loans$obstime,
                     "value"=ofi_loans$obsvalue,"type"=1,"flow"=ofi_loans$obsvalue)

icpf_loans<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.A.F.F4.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
icpf_loans<-data.frame(icpf_loans)
icpf_loans<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=11,"instrument"=loans,"time"=icpf_loans$obstime,
                      "value"=icpf_loans$obsvalue,"type"=1,"flow"=icpf_loans$obsvalue)

#no loans for icps
fi_loans<-iv_loans
fi_loans$flow<-iv_loans$flow+ofi_loans$flow+icpf_loans$flow

##debt securities
iv_debt_sec_st<-get_data("QSA.Q.N.I8.W0.S124.S1.N.A.F.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_debt_sec_st<-data.frame(iv_debt_sec_st)
iv_debt_sec_st<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=7,"instrument"=debt_sec,"time"=iv_debt_sec_st$obstime,
                        "value"=iv_debt_sec_st$obsvalue,"type"=1,"flow"=iv_debt_sec_st$obsvalue)

iv_debt_sec_lt<-get_data("QSA.Q.N.I8.W0.S124.S1.N.A.F.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_debt_sec_lt<-data.frame(iv_debt_sec_lt)
iv_debt_sec_lt<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=7,"instrument"=debt_sec,"time"=iv_debt_sec_lt$obstime,
                        "value"=iv_debt_sec_lt$obsvalue,"type"=1,"flow"=iv_debt_sec_lt$obsvalue)

ofi_debt_sec_st<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.A.F.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
ofi_debt_sec_st<-data.frame(ofi_debt_sec_st)
ofi_debt_sec_st<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=7,"instrument"=debt_sec,"time"=ofi_debt_sec_st$obstime,
                           "value"=ofi_debt_sec_st$obsvalue,"type"=1,"flow"=ofi_debt_sec_st$obsvalue)

ofi_debt_sec_lt<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.A.F.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
ofi_debt_sec_lt<-data.frame(ofi_debt_sec_lt)
ofi_debt_sec_lt<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=7,"instrument"=debt_sec,"time"=ofi_debt_sec_lt$obstime,
                           "value"=ofi_debt_sec_lt$obsvalue,"type"=1,"flow"=ofi_debt_sec_lt$obsvalue)

icpf_debt_sec_st<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.A.F.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
icpf_debt_sec_st<-data.frame(icpf_debt_sec_st)
icpf_debt_sec_st<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=7,"instrument"=debt_sec,"time"=icpf_debt_sec_st$obstime,
                            "value"=icpf_debt_sec_st$obsvalue,"type"=1,"flow"=icpf_debt_sec_st$obsvalue)

icpf_debt_sec_lt<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.A.F.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
icpf_debt_sec_lt<-data.frame(icpf_debt_sec_lt)
icpf_debt_sec_lt<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=7,"instrument"=debt_sec,"time"=icpf_debt_sec_lt$obstime,
                            "value"=icpf_debt_sec_lt$obsvalue,"type"=1,"flow"=icpf_debt_sec_lt$obsvalue)

fi_debt_sec<-iv_debt_sec_st
fi_debt_sec$flow<-iv_debt_sec_st$flow+iv_debt_sec_lt$flow+ofi_debt_sec_st$flow+ofi_debt_sec_lt$flow+icpf_debt_sec_st$flow+icpf_debt_sec_lt$flow

##equities
#listed shares
iv_listed_shares<-get_data("QSA.Q.N.I8.W0.S124.S1.N.A.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_listed_shares<-data.frame(iv_listed_shares)
iv_listed_shares<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=8,"instrument"=equities,"time"=iv_listed_shares$obstime,
                        "value"=iv_listed_shares$obsvalue,"type"=1,"flow"=iv_listed_shares$obsvalue)

ofi_listed_shares<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.A.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
ofi_listed_shares<-data.frame(ofi_listed_shares)
ofi_listed_shares<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=8,"instrument"=equities,"time"=ofi_listed_shares$obstime,
                             "value"=ofi_listed_shares$obsvalue,"type"=1,"flow"=ofi_listed_shares$obsvalue)

icpf_listed_shares<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.A.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
icpf_listed_shares<-data.frame(icpf_listed_shares)
icpf_listed_shares<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=8,"instrument"=equities,"time"=icpf_listed_shares$obstime,
                             "value"=icpf_listed_shares$obsvalue,"type"=1,"flow"=icpf_listed_shares$obsvalue)

fi_listed_shares<-iv_listed_shares
fi_listed_shares$flow<-iv_listed_shares$flow+ofi_listed_shares$flow+icpf_listed_shares$flow

#unlisted shares and other equity
iv_unlisted_shares<-get_data("QSA.Q.N.I8.W0.S124.S1.N.A.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_unlisted_shares<-data.frame(iv_unlisted_shares)
iv_unlisted_shares<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=8,"instrument"=equities,"time"=iv_unlisted_shares$obstime,
                             "value"=iv_unlisted_shares$obsvalue,"type"=1,"flow"=iv_unlisted_shares$obsvalue)

ofi_unlisted_shares<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.A.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
ofi_unlisted_shares<-data.frame(ofi_unlisted_shares)
ofi_unlisted_shares<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=8,"instrument"=equities,"time"=ofi_unlisted_shares$obstime,
                               "value"=ofi_unlisted_shares$obsvalue,"type"=1,"flow"=ofi_unlisted_shares$obsvalue)

icpf_unlisted_shares<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.A.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
icpf_unlisted_shares<-data.frame(icpf_unlisted_shares)
icpf_unlisted_shares<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=8,"instrument"=equities,"time"=icpf_unlisted_shares$obstime,
                               "value"=icpf_unlisted_shares$obsvalue,"type"=1,"flow"=icpf_unlisted_shares$obsvalue)

fi_unlisted_shares<-iv_unlisted_shares
fi_unlisted_shares$flow<-iv_unlisted_shares$flow+ofi_unlisted_shares$flow+icpf_unlisted_shares$flow

#iv fund shares
iv_iv_shares<-get_data("QSA.Q.N.I8.W0.S124.S1.N.A.F.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_iv_shares<-data.frame(iv_iv_shares)
iv_iv_shares<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=14,"instrument"=iv,"time"=iv_iv_shares$obstime,
                               "value"=iv_iv_shares$obsvalue,"type"=1,"flow"=iv_iv_shares$obsvalue)

ofi_iv_shares<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.A.F.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
ofi_iv_shares<-data.frame(ofi_iv_shares)
ofi_iv_shares<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=14,"instrument"=iv,"time"=ofi_iv_shares$obstime,
                         "value"=ofi_iv_shares$obsvalue,"type"=1,"flow"=ofi_iv_shares$obsvalue)

icpf_iv_shares<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.A.F.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
icpf_iv_shares<-data.frame(icpf_iv_shares)
icpf_iv_shares<-data.frame("id_holder"=3,"party"=ofi,"id_rec"=14,"instrument"=iv,"time"=icpf_iv_shares$obstime,
                         "value"=icpf_iv_shares$obsvalue,"type"=1,"flow"=icpf_iv_shares$obsvalue)

fi_iv_shares<-iv_iv_shares
fi_iv_shares$flow<-iv_iv_shares$flow+ofi_iv_shares$flow+icpf_iv_shares$flow
fi_equities<-fi_listed_shares
fi_equities$flow<-fi_listed_shares$flow+fi_unlisted_shares$flow

##total
#NOT USED
iv_bs<-get_data("IVF.Q.U2.N.T0.T00.A.1.Z5.0000.Z01.E",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_bs<-data.frame("id_holder"=3,"party"=ofi,"instrument"=total,"time"=iv_bs$obstime,"value"=iv_bs$obsvalue,"type"=3)

ofi_bs<-iv_bs

###3. corporates
##debt sec
nfc_debt_sec<-get_data("QSA.Q.N.I8.W0.S11.S1.N.A.F.F3.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
nfc_debt_sec<-data.frame(nfc_debt_sec)
nfc_debt_sec<-data.frame("id_holder"=4,"party"=nfc,"id_rec"=7,"instrument"=debt_sec,"time"=nfc_debt_sec$obstime,
                         "value"=nfc_debt_sec$obsvalue,"type"=1,"flow"=nfc_debt_sec$obsvalue)

##equities
nfc_listed_shares<-get_data("QSA.Q.N.I8.W0.S11.S1.N.A.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
nfc_listed_shares<-data.frame(nfc_listed_shares)
nfc_listed_shares<-data.frame("id_holder"=4,"party"=nfc,"id_rec"=8,"instrument"=equities,"time"=nfc_listed_shares$obstime,
                                "value"=nfc_listed_shares$obsvalue,"type"=1,"flow"=nfc_listed_shares$obsvalue)

nfc_unlisted_shares<-get_data("QSA.Q.N.I8.W0.S11.S1.N.A.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
nfc_unlisted_shares<-data.frame(nfc_unlisted_shares)
nfc_unlisted_shares<-data.frame("id_holder"=4,"party"=nfc,"id_rec"=8,"instrument"=equities,"time"=nfc_unlisted_shares$obstime,
                          "value"=nfc_unlisted_shares$obsvalue,"type"=1,"flow"=nfc_unlisted_shares$obsvalue)

nfc_iv_shares<-get_data("QSA.Q.N.I8.W0.S11.S1.N.A.F.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
nfc_iv_shares<-data.frame(nfc_iv_shares)
nfc_iv_shares<-data.frame("id_holder"=4,"party"=nfc,"id_rec"=14,"instrument"=iv,"time"=nfc_iv_shares$obstime,
                                "value"=nfc_iv_shares$obsvalue,"type"=1,"flow"=nfc_iv_shares$obsvalue)

nfc_equities<-nfc_listed_shares
nfc_equities$flow<-nfc_listed_shares$flow+nfc_unlisted_shares$flow

##investment
nfc_re<-get_data("QSA.Q.N.I8.W0.S11.S1.N.D.P51G._Z._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
nfc_re<-data.frame(nfc_re)
nfc_re<-data.frame("id_holder"=4,"party"=nfc,"id_rec"=12,"instrument"=re,"time"=nfc_re$obstime,
                   "value"=nfc_re$obsvalue,"type"=1,"flow"=nfc_re$obsvalue)
nfc_depreciation<-get_data("QSA.Q.N.I8.W0.S11.S1.N.D.P51C._Z._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
nfc_depreciation<-data.frame(nfc_depreciation)
nfc_depreciation<-data.frame("id_holder"=4,"party"=nfc,"id_rec"=12,"instrument"=re,"time"=nfc_depreciation$obstime,
                   "value"=nfc_depreciation$obsvalue,"type"=1,"flow"=nfc_depreciation$obsvalue)
nfc_re$flow<-nfc_re$flow-nfc_depreciation$flow

##total
#NOT USED
nfc_bs<-get_data("QSA.Q.N.I8.W0.S11.S1.N.A.F.F._Z._Z.XDC._T.S.V.N._T")
nfc_bs<-data.frame("id_holder"=4,"party"=nfc,"instrument"=total,"time"=nfc_bs$obstime,"value"=nfc_bs$obsvalue,"type"=3)

###4. govt
##debt securities
govt_debt_sec<-get_data("QSA.Q.N.I8.W0.S13.S1.N.A.F.F3.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
govt_debt_sec<-data.frame(govt_debt_sec)
govt_debt_sec<-data.frame("id_holder"=2,"party"=govt,"id_rec"=7,"instrument"=debt_sec,"time"=govt_debt_sec$obstime,
                           "value"=govt_debt_sec$obsvalue,"type"=1,"flow"=govt_debt_sec$obsvalue)
##investment
govt_re<-get_data("QSA.Q.N.I8.W0.S13.S1.N.D.P51G._Z._Z._T.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
govt_re<-data.frame(govt_re)
govt_re<-data.frame("id_holder"=2,"party"=govt,"id_rec"=12,"instrument"=re,"time"=govt_re$obstime,
                   "value"=govt_re$obsvalue,"type"=1,"flow"=govt_re$obsvalue)
govt_depreciation<-get_data("QSA.Q.N.I8.W0.S13.S1.N.D.P51C._Z._Z._T.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
govt_depreciation<-data.frame(govt_depreciation)
govt_depreciation<-data.frame("id_holder"=2,"party"=govt,"id_rec"=12,"instrument"=re,"time"=govt_depreciation$obstime,
                             "value"=govt_depreciation$obsvalue,"type"=1,"flow"=govt_depreciation$obsvalue)
govt_re$flow<-govt_re$flow-govt_depreciation$flow

#total
#NOT USED
govt_bs<-get_data("QSA.Q.N.I8.W0.S13.S1.N.A.LE.F._Z._Z.XDC._T.S.V.N._T")
govt_bs<-data.frame("id_holder"=2,"party"=govt,"instrument"=total,"time"=govt_bs$obstime,"value"=govt_bs$obsvalue,"type"=3)

###5. cb
##debt_sec
cb_debt_sec<- read.csv("balance sheet data/APP_breakdown_history_sum.csv",stringsAsFactors=FALSE,dec=",",header=TRUE)
cb_debt_sec<-data.frame(cb_debt_sec[-(7:10)])
cb_debt_sec<-data.frame("id_holder"=0,"party"=cb,"id_rec"=7,"instrument"=debt_sec,"time"=cb_debt_sec$X,
                           "value"=cb_debt_sec$Total,"type"=1,"flow"=cb_debt_sec$Total)

cb_bs<- data.frame(read.csv("balance sheet data/APP_bs.csv",stringsAsFactors=FALSE,dec=",",header=TRUE))
cb_bs<-data.frame("id_holder"=0,"party"=cb,"instrument"=total,"time"=cb_bs$X,"value"=cb_bs$Total,"type"=1)
##debt securities
#cb_debt_sec<-get_data("",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
#cb_debt_sec<-data.frame(cb_debt_sec)
#cb_debt_sec<-data.frame("id_holder"=4,"party"=govt,"id_rec"=7,"instrument"=debt_sec,"time"=cb_debt_sec$obstime,
#                          "value"=cb_debt_sec$obsvalue,"type"=1,"flow"=cb_debt_sec$obsvalue)

###6. hhs
##debt securities
hh_debt_sec_st<-get_data("QSA.Q.N.I8.W0.S1M.S1.N.A.F.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
hh_debt_sec_st<-data.frame(hh_debt_sec_st)
hh_debt_sec_st<-data.frame("id_holder"=6,"party"=hh,"id_rec"=7,"instrument"=debt_sec,"time"=hh_debt_sec_st$obstime,
                           "value"=hh_debt_sec_st$obsvalue,"type"=1,"flow"=hh_debt_sec_st$obsvalue)

hh_debt_sec_lt<-get_data("QSA.Q.N.I8.W0.S1M.S1.N.A.F.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
hh_debt_sec_lt<-data.frame(hh_debt_sec_lt)
hh_debt_sec_lt<-data.frame("id_holder"=6,"party"=hh,"id_rec"=7,"instrument"=debt_sec,"time"=hh_debt_sec_lt$obstime,
                           "value"=hh_debt_sec_lt$obsvalue,"type"=1,"flow"=hh_debt_sec_lt$obsvalue)

hh_debt_sec<-hh_debt_sec_lt
hh_debt_sec$flow<-hh_debt_sec_lt$flow+hh_debt_sec_st$flow

##equities
hh_listed_shares<-get_data("QSA.Q.N.I8.W0.S1M.S1.N.A.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
hh_listed_shares<-data.frame(hh_listed_shares)
hh_listed_shares<-data.frame("id_holder"=6,"party"=hh,"id_rec"=8,"instrument"=equities,"time"=hh_listed_shares$obstime,
                         "value"=hh_listed_shares$obsvalue,"type"=1,"flow"=hh_listed_shares$obsvalue)

hh_iv_shares<-get_data("QSA.Q.N.I8.W0.S1M.S1.N.A.F.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
hh_iv_shares<-data.frame(hh_iv_shares)
hh_iv_shares<-data.frame("id_holder"=6,"party"=hh,"id_rec"=14,"instrument"=iv,"time"=hh_iv_shares$obstime,
                             "value"=hh_iv_shares$obsvalue,"type"=1,"flow"=hh_iv_shares$obsvalue)

hh_unlisted_shares<-get_data("QSA.Q.N.I8.W0.S1M.S1.N.A.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
hh_unlisted_shares<-data.frame(hh_unlisted_shares)
hh_unlisted_shares<-data.frame("id_holder"=6,"party"=hh,"id_rec"=8,"instrument"=equities,"time"=hh_unlisted_shares$obstime,
                        "value"=hh_unlisted_shares$obsvalue,"type"=1,"flow"=hh_unlisted_shares$obsvalue)

hh_equities<-hh_listed_shares
hh_equities$flow<-hh_listed_shares$flow+hh_unlisted_shares$flow

##re
hh_re<-get_data("QSA.Q.N.I8.W0.S1M.S1.N.D.P51G._Z._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
hh_re<-data.frame(hh_re)
hh_re<-data.frame("id_holder"=6,"party"=hh,"id_rec"=12,"instrument"=re,"time"=hh_re$obstime,
                               "value"=hh_re$obsvalue,"type"=1,"flow"=hh_re$obsvalue)
hh_depreciation<-get_data("QSA.Q.N.I8.W0.S1M.S1.N.D.P51C._Z._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
hh_depreciation<-data.frame(hh_depreciation)
hh_depreciation<-data.frame("id_holder"=6,"party"=hh,"id_rec"=12,"instrument"=re,"time"=hh_depreciation$obstime,
                  "value"=hh_depreciation$obsvalue,"type"=1,"flow"=hh_depreciation$obsvalue)
hh_re$flow<-hh_re$flow-hh_depreciation$flow

##total
#UNUSED
hh_bs<-get_data("QSA.Q.N.I8.W0.S1M.S1.N.A.LE.F._Z._Z.XDC._T.S.V.N._T")
hh_bs<-data.frame("id_holder"=6,"party"=hh,"instrument"=total,"time"=hh_bs$obstime,"value"=hh_bs$obsvalue,"type"=3)

###12. re
##total
#UNUSED
re_bs<-get_data("QSA.Q.N.I8.W0.S1M.S1._Z.D.LE.NYN._Z._Z.EUR._Z.S.V.N._T")
re_bs<-data.frame("id_holder"=12,"party"=re,"instrument"=total,"time"=re_bs$obstime,"value"=re_bs$obsvalue,"type"=4)

###13. insurance and pension funds

###7. debt securities
#mfis
debt_sec_st_mfi<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.F.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_st_mfi<-data.frame(debt_sec_st_mfi)
debt_sec_st_mfi<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=1,"instrument"=mfi,"time"=debt_sec_st_mfi$obstime,
                            "value"=debt_sec_st_mfi$obsvalue,"type"=2,"flow"=debt_sec_st_mfi$obsvalue)

debt_sec_lt_mfi<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.F.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_lt_mfi<-data.frame(debt_sec_lt_mfi)
debt_sec_lt_mfi<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=1,"instrument"=mfi,"time"=debt_sec_lt_mfi$obstime,
                            "value"=debt_sec_lt_mfi$obsvalue,"type"=2,"flow"=debt_sec_lt_mfi$obsvalue)

debt_sec_mfi<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=1,"instrument"=mfi,"time"=debt_sec_lt_mfi$time,
                         "value"=debt_sec_lt_mfi$value+debt_sec_st_mfi$value,"type"=2,"flow"=debt_sec_lt_mfi$value+debt_sec_st_mfi$value)

#fis
debt_sec_st_iv<-get_data("QSA.Q.N.I8.W0.S124.S1.N.L.F.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_st_iv<-data.frame(debt_sec_st_iv)
debt_sec_st_iv<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=3,"instrument"=ofi,"time"=debt_sec_st_iv$obstime,
                        "value"=debt_sec_st_iv$obsvalue,"type"=2,"flow"=debt_sec_st_iv$obsvalue)

debt_sec_st_ofi<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.L.F.F3.S._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_st_ofi<-data.frame(debt_sec_st_ofi)
debt_sec_st_ofi<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=3,"instrument"=ofi,"time"=debt_sec_st_ofi$obstime,
                        "value"=debt_sec_st_ofi$obsvalue,"type"=2,"flow"=debt_sec_st_ofi$obsvalue)

#all maturities!!!
debt_sec_icpf<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.L.F.F3.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_icpf<-data.frame(debt_sec_icpf)
debt_sec_icpf<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=3,"instrument"=ofi,"time"=debt_sec_icpf$obstime,
                        "value"=debt_sec_icpf$obsvalue,"type"=2,"flow"=debt_sec_icpf$obsvalue)

debt_sec_lt_iv<-get_data("QSA.Q.N.I8.W0.S124.S1.N.L.F.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_lt_iv<-data.frame(debt_sec_lt_iv)
debt_sec_lt_iv<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=3,"instrument"=ofi,"time"=debt_sec_lt_iv$obstime,
                           "value"=debt_sec_lt_iv$obsvalue,"type"=2,"flow"=debt_sec_lt_iv$obsvalue)

debt_sec_lt_ofi<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.L.F.F3.L._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_lt_ofi<-data.frame(debt_sec_lt_ofi)
debt_sec_lt_ofi<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=3,"instrument"=ofi,"time"=debt_sec_lt_ofi$obstime,
                            "value"=debt_sec_lt_ofi$obsvalue,"type"=2,"flow"=debt_sec_lt_ofi$obsvalue)

debt_sec_fi<-debt_sec_st_iv
debt_sec_fi$flow<-debt_sec_st_iv$flow+debt_sec_lt_iv$flow+debt_sec_st_ofi$flow+debt_sec_lt_ofi$flow+debt_sec_icpf$flow

##nfc
debt_sec_nfc<-get_data("QSA.Q.N.I8.W0.S11.S1.N.L.F.F3.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_nfc<-data.frame(debt_sec_nfc)
debt_sec_nfc<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=4,"instrument"=nfc,"time"=debt_sec_nfc$obstime,
                         "value"=debt_sec_nfc$obsvalue,"type"=2,"flow"=debt_sec_nfc$obsvalue)

##govt
debt_sec_govt<-get_data("QSA.Q.N.I8.W0.S13.S1.N.L.F.F3.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
debt_sec_govt<-data.frame(debt_sec_govt)
debt_sec_govt<-data.frame("id_holder"=7,"party"=debt_sec,"id_rec"=2,"instrument"=govt,"time"=debt_sec_govt$obstime,
                         "value"=debt_sec_govt$obsvalue,"type"=2,"flow"=debt_sec_govt$obsvalue)

debt_sec_bs<-data.frame("id_holder"=7,"party"=debt_sec,"instrument"=total,"time"=debt_sec_nfc$time,"value"=instr_dummy,"type"=2)

###8. equities
#mfi
#listed shares
listed_shares_mfi<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
listed_shares_mfi<-data.frame(listed_shares_mfi)
listed_shares_mfi<-data.frame("id_holder"=8,"party"=equities,"id_rec"=1,"instrument"=mfi,"time"=listed_shares_mfi$obstime,
                              "value"=listed_shares_mfi$obsvalue,"type"=2,"flow"=listed_shares_mfi$obsvalue)

#unlisted shares
unlisted_shares_mfi<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
unlisted_shares_mfi<-data.frame(unlisted_shares_mfi)
unlisted_shares_mfi<-data.frame("id_holder"=8,"party"=equities,"id_rec"=1,"instrument"=mfi,"time"=unlisted_shares_mfi$obstime,
                          "value"=unlisted_shares_mfi$obsvalue,"type"=2,"flow"=unlisted_shares_mfi$obsvalue)

#iv shares
iv_shares_mfi<-get_data("QSA.Q.N.I8.W0.S12K.S1.N.L.F.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_shares_mfi<-data.frame(iv_shares_mfi)
iv_shares_mfi<-data.frame("id_holder"=14,"party"=iv,"id_rec"=1,"instrument"=mfi,"time"=iv_shares_mfi$obstime,
                          "value"=iv_shares_mfi$obsvalue,"type"=2,"flow"=iv_shares_mfi$obsvalue)

equities_mfi<-data.frame("id_holder"=8,"party"=equities,"id_rec"=1,"instrument"=mfi,"time"=iv_shares_mfi$time,
                         "value"=listed_shares_mfi$value+unlisted_shares_mfi$value,"type"=2,"flow"=unlisted_shares_mfi$value+listed_shares_mfi$value)

#fi
listed_shares_iv<-get_data("QSA.Q.N.I8.W0.S124.S1.N.L.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
listed_shares_iv<-data.frame(listed_shares_iv)
listed_shares_iv<-data.frame("id_holder"=8,"party"=equities,"id_rec"=3,"instrument"=ofi,"time"=listed_shares_iv$obstime,
                              "value"=listed_shares_iv$obsvalue,"type"=2,"flow"=listed_shares_iv$obsvalue)

listed_shares_ofi<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.L.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
listed_shares_ofi<-data.frame(listed_shares_ofi)
listed_shares_ofi<-data.frame("id_holder"=8,"party"=equities,"id_rec"=3,"instrument"=ofi,"time"=listed_shares_ofi$obstime,
                             "value"=listed_shares_ofi$obsvalue,"type"=2,"flow"=listed_shares_ofi$obsvalue)

listed_shares_icpf<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.L.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
listed_shares_icpf<-data.frame(listed_shares_icpf)
listed_shares_icpf<-data.frame("id_holder"=8,"party"=equities,"id_rec"=3,"instrument"=ofi,"time"=listed_shares_icpf$obstime,
                              "value"=listed_shares_icpf$obsvalue,"type"=2,"flow"=listed_shares_icpf$obsvalue)

unlisted_shares_iv<-get_data("QSA.Q.N.I8.W0.S124.S1.N.L.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
unlisted_shares_iv<-data.frame(unlisted_shares_iv)
unlisted_shares_iv<-data.frame("id_holder"=8,"party"=equities,"id_rec"=3,"instrument"=ofi,"time"=unlisted_shares_iv$obstime,
                             "value"=unlisted_shares_iv$obsvalue,"type"=2,"flow"=unlisted_shares_iv$obsvalue)

unlisted_shares_ofi<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.L.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
unlisted_shares_ofi<-data.frame(unlisted_shares_ofi)
unlisted_shares_ofi<-data.frame("id_holder"=8,"party"=equities,"id_rec"=3,"instrument"=ofi,"time"=unlisted_shares_ofi$obstime,
                              "value"=unlisted_shares_ofi$obsvalue,"type"=2,"flow"=unlisted_shares_ofi$obsvalue)

unlisted_shares_icpf<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.L.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
unlisted_shares_icpf<-data.frame(unlisted_shares_icpf)
unlisted_shares_icpf<-data.frame("id_holder"=8,"party"=equities,"id_rec"=3,"instrument"=ofi,"time"=unlisted_shares_icpf$obstime,
                               "value"=unlisted_shares_icpf$obsvalue,"type"=2,"flow"=unlisted_shares_icpf$obsvalue)

iv_shares_iv<-get_data("QSA.Q.N.I8.W0.S124.S1.N.L.F.F52._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
iv_shares_iv<-data.frame(iv_shares_iv)
iv_shares_iv<-data.frame("id_holder"=14,"party"=iv,"id_rec"=3,"instrument"=ofi,"time"=iv_shares_iv$obstime,
                          "value"=iv_shares_iv$obsvalue,"type"=2,"flow"=iv_shares_iv$obsvalue)

#no iv shares issued by ofis as per definition all investment fund shares issuing non-banks in iv (and corresponding data entry doesn't exist in the sdw)

#iv shares issued by icpf zero value for entire available period

iv_shares_fi<-iv_shares_iv

equities_fi<-listed_shares_iv
equities_fi$flow<-listed_shares_iv$flow+unlisted_shares_iv$flow+listed_shares_ofi$flow+unlisted_shares_ofi$flow+listed_shares_icpf$flow+unlisted_shares_icpf$flow

#equity issued by nfc
listed_shares_nfc<-get_data("QSA.Q.N.I8.W0.S11.S1.N.L.F.F511._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
listed_shares_nfc<-data.frame(listed_shares_nfc)
listed_shares_nfc<-data.frame("id_holder"=8,"party"=equities,"id_rec"=4,"instrument"=nfc,"time"=listed_shares_nfc$obstime,
                         "value"=listed_shares_nfc$obsvalue,"type"=2,"flow"=listed_shares_nfc$obsvalue)

unlisted_shares_nfc<-get_data("QSA.Q.N.I8.W0.S11.S1.N.L.F.F51M._Z._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
unlisted_shares_nfc<-data.frame(unlisted_shares_nfc)
unlisted_shares_nfc<-data.frame("id_holder"=8,"party"=equities,"id_rec"=4,"instrument"=nfc,"time"=unlisted_shares_nfc$obstime,
                              "value"=unlisted_shares_nfc$obsvalue,"type"=2,"flow"=unlisted_shares_nfc$obsvalue)

equities_nfc<-listed_shares_nfc
equities_nfc$flow<-listed_shares_nfc$flow+unlisted_shares_nfc$flow

equities_bs<-data.frame("id_holder"=8,"party"=equities,"instrument"=total,"time"=equities_nfc$time,"value"=instr_dummy,"type"=2)
iv_shares_bs<-data.frame("id_holder"=14,"party"=iv,"instrument"=total,"time"=equities_nfc$time,"value"=instr_dummy,"type"=2)

###9. loans
##govt
loans_govt<-get_data("QSA.Q.N.I8.W0.S13.S1.N.L.F.F4.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
loans_govt<-data.frame(loans_govt)
loans_govt<-data.frame("id_holder"=11,"party"=loans,"id_rec"=2,"instrument"=govt,"time"=loans_govt$obstime,
                     "value"=loans_govt$obsvalue,"type"=2,"flow"=loans_govt$obsvalue)

##fi
loans_iv<-get_data("QSA.Q.N.I8.W0.S124.S1.N.L.F.F4.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
loans_iv<-data.frame(loans_iv)
loans_iv<-data.frame("id_holder"=11,"party"=loans,"id_rec"=3,"instrument"=ofi,"time"=loans_iv$obstime,
                     "value"=loans_iv$obsvalue,"type"=2,"flow"=loans_iv$obsvalue)

loans_ofi<-get_data("QSA.Q.N.I8.W0.S12O.S1.N.L.F.F4.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
loans_ofi<-data.frame(loans_ofi)
loans_ofi<-data.frame("id_holder"=11,"party"=loans,"id_rec"=3,"instrument"=ofi,"time"=loans_ofi$obstime,
                     "value"=loans_ofi$obsvalue,"type"=2,"flow"=loans_ofi$obsvalue)

loans_icpf<-get_data("QSA.Q.N.I8.W0.S12Q.S1.N.L.F.F4.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
loans_icpf<-data.frame(loans_icpf)
loans_icpf<-data.frame("id_holder"=11,"party"=loans,"id_rec"=3,"instrument"=ofi,"time"=loans_icpf$obstime,
                      "value"=loans_icpf$obsvalue,"type"=2,"flow"=loans_icpf$obsvalue)

loans_fi<-loans_iv
loans_fi$flow<-loans_iv$flow+loans_ofi$flow+loans_icpf$flow

##hhs
loans_hh<-get_data("QSA.Q.N.I8.W0.S1M.S1.N.L.F.F4.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
loans_hh<-data.frame(loans_hh)
loans_hh<-data.frame("id_holder"=11,"party"=loans,"id_rec"=6,"instrument"=hh,"time"=loans_hh$obstime,
                      "value"=loans_hh$obsvalue,"type"=2,"flow"=loans_hh$obsvalue)

##nfc
loans_nfc<-get_data("QSA.Q.N.I8.W0.S11.S1.N.L.F.F4.T._Z.XDC._T.S.V.N._T",filter=list(startPeriod=startPeriod,endPeriod=endPeriod))
loans_nfc<-data.frame(loans_nfc)
loans_nfc<-data.frame("id_holder"=11,"party"=loans,"id_rec"=4,"instrument"=nfc,"time"=loans_nfc$obstime,
                      "value"=loans_nfc$obsvalue,"type"=2,"flow"=loans_nfc$obsvalue)

loans_bs<-data.frame("id_holder"=11,"party"=loans,"instrument"=total,"time"=loans_nfc$time,"value"=instr_dummy,"type"=2)

###-----------------------------------------------------------------------------------------------------------###
###data files
##nodes
#--deposits removed for now for clarity--#
nodes<-rbind(mfi_bs,ofi_bs,nfc_bs,govt_bs,hh_bs,debt_sec_bs,equities_bs,loans_bs,re_bs,iv_shares_bs,cb_bs)
nodes<-rename(nodes,c("id_holder"="id"))
nodes$value<-as.integer(nodes$value/1000)

##edges
mfi_edges<-rbind(mfi_debt_sec,mfi_equities,mfi_loans,mfi_iv_shares)
fi_edges<-rbind(fi_debt_sec,fi_equities,fi_loans,fi_iv_shares)
nfc_edges<-rbind(nfc_debt_sec,nfc_equities,nfc_re,nfc_iv_shares)
govt_edges<-rbind(govt_debt_sec,govt_re)
hh_edges<-rbind(hh_debt_sec,hh_equities,hh_re,hh_iv_shares)
cb_edges<-rbind(cb_debt_sec)
debt_sec_edges<-rbind(debt_sec_mfi,debt_sec_nfc,debt_sec_govt,debt_sec_fi)
equities_edges<-rbind(equities_mfi,equities_fi,equities_nfc)
loans_edges<-rbind(loans_fi,loans_nfc,loans_hh,loans_govt)
iv_shares_edges<-rbind(iv_shares_mfi,iv_shares_fi)
edges<-rbind(mfi_edges,fi_edges,govt_edges,nfc_edges,hh_edges,debt_sec_edges,equities_edges,loans_edges,iv_shares_edges,cb_edges)
edges<-rename(edges,c("id_holder"="from","id_rec"="to"))
#edges<-transform(edges,from=ifelse(flow<0,to,from),party=ifelse(flow<0,instrument,party),to=ifelse(flow<0,from,to),
#                 instrument=ifelse(flow<0,party,instrument))
#edges<-transform(edges,flow=ifelse(flow<0,flow*(-1),flow))
edges<-subset(edges,select=-value)
edges$flow<-as.integer(edges$flow/1000)
edges<-ddply(edges,.(from,to,time),summarize,flow=sum(flow),type)
colnames(edges)[5]<-"type"

setwd("./data/nodes")
quarter<-0
year<-as.integer(startPeriod)-1
distance<-as.integer(startPeriod)+(as.integer(endPeriod)-as.integer(startPeriod))*4
for (i in startPeriod:distance) {
  quarter<-ifelse(quarter==4,1,quarter+1)
  year<-ifelse(quarter==1,year+1,year)
  date<-paste0(year,"-Q",quarter)
  file<-paste("nodes",date,".csv",sep="")
  write.csv(nodes[grepl(date,nodes$time),],file)
  if (year==as.integer(endPeriod) && quarter==as.integer(lastQuarter)) break
}

setwd("../edges")
quarter<-0
year<-as.integer(startPeriod)-1
for (i in startPeriod:distance) {
  quarter<-ifelse(quarter==4,1,quarter+1)
  year<-ifelse(quarter==1,year+1,year)
  date<-paste0(year,"-Q",quarter)
  file<-paste("edges",date,".csv",sep="")
  write.csv(edges[grepl(date,edges$time),],file)
  if (year==as.integer(endPeriod) && quarter==as.integer(lastQuarter)) break
}

