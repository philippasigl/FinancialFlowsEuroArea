library(visNetwork)
#setwd('C:/Users/Philippa/Desktop/Econ research/Follow The Money/microblog/finflows')


files <- list.files(path = "data/nodes")
nodes <- list()
for (t in 1:length(files)) {
#read in nodes
  nodes[[t]] <- read.csv(paste0("data/nodes/",files[t]))
  #add image
#  for (j in 1:nrow(nodes[[i]])) {
   
#  if (nodes[[i]]$id[j]==0) {
#   nodes[[i]]$image[j]=img_cb
#  }
#  else if (nodes[[i]]$id[j]==1) {
#    nodes[[i]]$image[j]=img_mfi
#  }
#  else if (nodes[[i]]$id[j]==2) {
#    nodes[[i]]$image[j]=img_govt
#  }
#  else if (nodes[[i]]$id[j]==3) {
#    nodes[[i]]$image[j]=img_ofi
#  }
#  else if (nodes[[i]]$id[j]==4) {
#    nodes[[i]]$image[j]=img_nfc
#  }
#  else if (nodes[[i]]$id[j]==6) {
#    nodes[[i]]$image[j]=img_hh
# }
#  else if (nodes[[i]]$id[j]==12) {
#   nodes[[i]]$image[j]=img_re
#  }

#  else { 
#    nodes[[i]]$image[j]=img_asset

# }
#}
#add other properties
  col.high<-'rgba(193,205,205,1)'
  col.high.b<-'rgba(193,205,215,1)'
  nodes[[t]]<-data.frame(nodes[[t]],
   shape ="dot",
   label=nodes[[t]]$party,
   labelHighlightBold=TRUE,
   font='8px helvetica black',
   group=nodes[[t]]$type,
   title=ifelse(nodes[[t]]$type==2,"",paste0(HTML("&#8364;"), nodes[[t]]$value," billion")),
   level=nodes[[t]]$type,
   color=list(background="white",border="grey",highlight=list(background=col.high,border=col.high.b)),
   scaling=list(min=10,max=10,enabled=TRUE),
#   scaling.label.enabled=FALSE,
#  widthConstraint=list(enabled=TRUE,minimum=40,maximum=40),
   borderWidth=0.5                     
   )
}


files <- list.files(path = "data/edges")
edges <- list()
for (t in 1:length(files)) {
  edges[[t]] <- read.csv(paste0("data/edges/",files[t]))
  positives<-list()
  negatives<-list()
  positives<-edges[[t]][as.integer(edges[[t]]$flow)>0,]
  negatives<-edges[[t]][as.integer(edges[[t]]$flow)<=0,]
  if (nrow(negatives)>0) {
    negatives<-data.frame(negatives,
                         arrows =list(to = list(enabled = FALSE,scaleFactor=0),from = list(enabled = TRUE,scaleFactor=0.2)),
                        arrowStrikethrough=FALSE,
                         title=paste0(HTML("&#8364;"),negatives$flow," billion"),
                         width=negatives$flow/10,
                       physics=FALSE
    )
  }
  positives<-data.frame(positives,
                         arrows =list(to = list(enabled = TRUE,scaleFactor=0.2),from = list(enabled = FALSE,scaleFactor=0)),
                        arrowStrikethrough=FALSE,
                         title=paste0(HTML("&#8364;"),positives$flow," billion"),
                         width=positives$flow/10,
                        physics=FALSE
  )
  edges[[t]]<-rbind(negatives,positives)
  col1<-'rgba(76, 126, 225, 0.8)'
  col2<-'rgba(102, 229, 117, 0.8)'
  edges[[t]]$color<-ifelse(edges[[t]]$type==1,col1,col2)
#  edges[[t]]$color.opacity<-0.1
}


#  edges[[i]]<-data.frame(edges[[i]],
#                         arrows =list(to = list(enabled = TRUE, scaleFactor = 0.3)),
#                         color="grey",
#                         label=edges[[i]]$flow,
#                         width=edges[[i]]$flow/50
#                         )
#}

#edges<-read.csv('C:/Users/Philippa/Desktop/Econ research/Follow The Money/microblog/edges.csv')
#nodes<-data.frame(nodes,label=nodes$party,group=nodes$type,value=nodes$volume,level=nodes$type)
#edges<-data.frame(edges,width=edges$weight,arrows =list(to = list(enabled = FALSE, scaleFactor = 0.1)),group=edges$type,color="grey")
net<-list()
for (t in 1:length(files)) {
  net[[t]]<-visNetwork(nodes[[t]],edges[[t]],height="200px",width="100%")%>%
  visEdges(smooth=list(enabled=TRUE,type="curvedCW",roundness=0.3))%>%
  visNodes(shapeProperties = list(useBorderWithImage = FALSE),color=list(border='black', background='white')) %>%
  visHierarchicalLayout(direction="LR",nodeSpacing=150,levelSeparation=250)%>%
  visConfigure(enabled=FALSE)%>%
  visOptions(highlightNearest = list(enabled =TRUE, degree = 1), nodesIdSelection=list(enabled=FALSE))%>%
  visInteraction(dragNodes = FALSE,selectable=TRUE,selectConnectedEdges=TRUE)
#only possible solver value for hierarchical layout
#visPhysics(solver='hierarchicalRepulsion')
  net[[t]]$x$tooltipStyle<-"position: fixed;visibility:hidden;padding: 5px;white-space: nowrap;font-family: helvetica;
  font-size:14px;font-color:#000000;background-color: #edf2f9;-moz-border-radius: 3px;-webkit-border-radius: 3px;
  border-radius: 3px;border: 1px solid #808074;box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);"
}



