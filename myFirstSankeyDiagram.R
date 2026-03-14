# Library
library(networkD3)
library(dplyr)

# A connection data frame is a list of flows with intensity for each flow
links <- data.frame(
  source=c("Indeed","Indeed", "ZipRecruiter", "ZipRecruiter", "LinkedIn", "LinkedIn", "Government_Sites", 
           "Government_Sites", "Company_Sites", "Company_Sites", "GIS_Jobs", "GIS_Jobs", "Other_Jobs", 
           "Other_Jobs", "Cover_Letter", "Cover_Letter", "Cover_Letter", "No_Cover", "No_Cover",
           "No_Cover"), 
  target=c("GIS_Jobs","Other_Jobs", "GIS_Jobs", "Other_Jobs", "GIS_Jobs", "Other_Jobs", "GIS_Jobs", 
           "Other_Jobs", "GIS_Jobs", "Other_Jobs", "Cover_Letter", "No_Cover", "Cover_Letter", 
           "No_Cover", "Not_Selected", "Ghosted", "Pending", "Not_Selected", "Ghosted", "Pending"), 
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

# Adding a color scale, which does not appreciate spaces between words
my_color <- 'd3.scaleOrdinal() .domain(["Indeed", "ZipRecruiter","LinkedIn", "Government_Sites", 
"Company_Sites", "GIS_Jobs", "Other_Jobs", "Cover_Letter", "No_Cover", "Not_Selected", "Ghosted",
"Pending"]) .range(["#00008B", "#32CD32", "#4169E1", "#8B4513" , "#FF8C00", "#228B22", "#98FB98", 
"#70E0D0", "#E0FFFF", "#FF6347", "#DCDCDC", "#F0E68C"])'

# Make the Network
p <- sankeyNetwork(Links = links, Nodes = nodes,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "value", NodeID = "name", colourScale = my_color,
                   sinksRight=FALSE)
p

# save the widget
# library(htmlwidgets)
# saveWidget(p, file=paste0( getwd(), "/HtmlWidget/sankeyBasic1.html"))