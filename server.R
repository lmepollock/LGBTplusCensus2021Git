library(shiny)

server <- function(input, output, session) {
  
  # declare reactives
  hexLabel <- reactiveVal(
    create_labels(msoa, varnames[[1]])
  )
  
  #startFlag <- reactiveVal(0)
  
  zoomDestination <- reactiveVal()
  
  output$map <- renderLeaflet({
    
    draw_initial_map(msoa,
                     varnames[[1]],
                     hexLabel()) #%>% 
     # draw_msoa_with_labels(msoa,
     #                       varnames[[1]],
      #                      create_labels(msoa, varnames[[1]])
      #                      )
  })
  
  prx <- leafletProxy("map")
  
  observeEvent(input$valToggle,
               {

                   hexLabel(
                     create_labels(msoa, input$valToggle)
                   )
               
                   prx %>% 
                     draw_msoa_with_labels(msoa,
                                           input$valToggle,
                                           hexLabel()
                                           )
                   
               })
  
  observeEvent(input$map_shape_click,
               {
                 req(input$map_shape_click$id)
                 
                 if (input$map_shape_click$id %in% group$group_labe) {
                   
                   zoomDestination(
                     filter(msoa, group_labe == input$map_shape_click$id) %>% 
                       st_bbox()
                   )
                   
                   prx %>% fitBounds(
                     zoomDestination()[[1]],
                     zoomDestination()[[2]],
                     zoomDestination()[[3]],
                     zoomDestination()[[4]]
                   ) %>%
                     hideGroup("groupBase")
                   
                 } else if(input$map_shape_click$id %in% msoa$msoa21cd) {
                   
                   msoas <- filter(msoa, msoa21cd == input$map_shape_click$id)
                   zoomDestination(
                     filter(msoa, group_labe == msoas$group_labe[[1]]) %>% 
                       st_bbox()
                   )
               
                   prx %>% fitBounds(
                     zoomDestination()[[1]],
                     zoomDestination()[[2]],
                     zoomDestination()[[3]],
                     zoomDestination()[[4]]
                   ) 
                   
                 }
               })
  
  
  observeEvent(input$reset,
               {
                 zoomDestination(
                   st_bbox(msoa)
                 )
                 prx %>% 
                   showGroup("groupBase") %>% 
                   fitBounds(zoomDestination()[[1]],
                               zoomDestination()[[2]],
                               zoomDestination()[[3]],
                               zoomDestination()[[4]])
               })
}