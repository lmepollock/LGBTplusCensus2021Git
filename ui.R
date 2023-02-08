library(shiny)

ui <- fluidPage(

    tags$head(
      tags$style(HTML('.leaflet-container { background: #ffffff};'))),
      tags$style(HTML('.selectize-dropdown-content {max-height: 500px};')),
    
    
    leafletOutput("map", width = "850px", height = "700px")
    
    
    ,style='width: 850px; height: 700px; float:left'
    
)