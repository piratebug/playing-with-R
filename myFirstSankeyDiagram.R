# Library
library(networkD3)
library(dplyr)

# A connection data frame is a list of flows with intensity for each flow
links <- data.frame(
  source=c("Indeed","Indeed", "ZipRecruiter", "ZipRecruiter", "LinkedIn", "LinkedIn", "Government Sites", 
           "Government Sites", "Company Sites", "Company Sites", "GIS Jobs", "GIS Jobs", "Other Jobs", 
           "Other Jobs", "Cover Letter", "Cover Letter", "Cover Letter", "No Cover Letter", "No Cover Letter",
           "No Cover Letter"), 
  target=c("GIS Jobs","Other Jobs", "GIS Jobs", "Other Jobs", "GIS Jobs", "Other Jobs", "GIS Jobs", 
           "Other Jobs", "GIS Jobs", "Other Jobs", "Cover Letter", "No Cover Letter", "Cover Letter", 
           "No Cover Letter", "Not Selected", "Ghosted", "Pending", "Not Selected", "Ghosted", "Pending"), 
  value=c(4,21,2,3,11,5,9,2,26,17,15,37,9,39,18,3,3,27,27,22)
)

# From these flows we need to create a node data frame: it lists every entities involved in the flow
nodes <- data.frame(
  name=c(as.character(links$source), 
         as.character(links$target)) %>% unique()
)

# With networkD3, connection must be provided using id, not using real name like in the links dataframe.. So we need to reformat it.
links$IDsource <- match(links$source, nodes$name)-1 
links$IDtarget <- match(links$target, nodes$name)-1

# Make the Network
p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name", 
                   sinksRight=FALSE)
p

# save the widget
# library(htmlwidgets)
# saveWidget(p, file=paste0( getwd(), "/HtmlWidget/sankeyBasic1.html"))