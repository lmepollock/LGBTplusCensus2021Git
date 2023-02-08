
# create labels
create_labels <- function(data, variable) {
  sprintf(
    
    "<strong>%s</strong> <br>
    %s <br> 
  Local authority: %s <br>
  Value: %1.2f%%",
  data$group_labe,
  data$msoa21hcln,
  data$lad22nm,
  as.numeric( dplyr::pull(data, variable) )
  ) %>% lapply(htmltools::HTML)
}

# create domain
create_domain <- function(data, variable) {
  c(
    min(pull(data, variable)),
    max(pull(data, variable))
  )
}



draw_initial_map <- function(msoa,
                             variable,
                             labelS){

  leaflet(msoa,
          options = leafletOptions(crs = crs,
                                   zoomSnap = 0.25,
                                   zoomDelta=0.25)) %>% 
    # panes
    addMapPane("background", 405) %>% 
    addMapPane("msoaPane", 460) %>% 
    addMapPane("ladPane", 480) %>% 
    addMapPane("groupPane", 470) %>% 
    # background layer
    addPolygons(group = "background",
                data = background,
                fillColor = "#777777",
                stroke = FALSE) %>% 
    
    # lad shape layer
    addPolylines(group = "ladBase",
                 data = lad,
                 color = "gainsboro",
                 opacity = 0.5,
                 weight = 0.8,
                 fillOpacity = 0,
                 layerId = ~lad22cd,
                 options = pathOptions(
                   pane = "ladPane"
                 )) %>% 
    # region/group layer
    addPolygons(group = "groupBase",
                 data = group,
                 color = "black",
                 weight = 2,
                 fillOpacity = 0,
                 layerId = ~group_labe,
                   highlightOptions = highlightOptions(
                    color = "white",
                    opacity = 1,
                    weight = 4,
                    bringToFront = TRUE
                 ),
                 label = group$group_labe,
                labelOptions = labelOptions(textsize = "12px"),
                 options = pathOptions(
                   pane = "groupPane"
                 )
    ) %>% 
    
    # controls
    addControl(actionButton("reset", "Region view")) %>% 
    addControl(selectInput("valToggle",
                           "Select a variable",
                           choices = setNames(varnames, 
                                              c("All LGB+ sexual orientations",
                                                "Gay or lesbian",
                                                "Bisexual and other LGB+ orientations",
                                                "All with gender identity different from sex at birth",
                                                "Trans men and trans women",
                                                "Other specified gender identity",
                                                "Different gender identity, not specified")),
                           selected = varnames[[1]],
                           width = "150px"))
  
}

# draw with labels
draw_msoa_with_labels <- function(prx,
                                  groupMsoas,
                                  variable,
                                  label2draw){
  
  dom <- create_domain(groupMsoas, variable)
  colFuncS <- colorBin(pal[variable][[1]],
                       dom,
                       bins = bins[variable][[1]])
  
  
  prx %>% 
    clearGroup(c("msoa")) %>%
    addPolygons(data = groupMsoas,
                group = "msoa",
                color = "#222222",
                weight = 0.9,
                fillColor = ~colFuncS(pull(groupMsoas, variable)),
                fillOpacity = 1,
                stroke = TRUE,
                layerId = ~msoa21cd,
                smoothFactor = 0.5,
                highlightOptions = highlightOptions(
                  bringToFront = TRUE,
                  color = "blue",
                  weight = 2.1
                ),
                label = label2draw,
                labelOptions = labelOptions(textsize = "12px"),
                options = pathOptions(
                  pane = "msoaPane"
                )
    ) %>% 
    removeControl("legend") %>% 
    addLegend(group = "msoa",
              position = "topright",
              colors = pal[variable][[1]],
            #  title = variable,
              layerId = "legend",
              labels = legColours[variable][[1]]
              )
            
}

# respond to reset button 
reset_maps <- function(prx, mapData) {
  
  bounds <- sf::st_bbox(mapData)
  
  prx %>% 
    fitBounds(bounds[[1]],
                bounds[[2]],
                bounds[[3]],
                bounds[[4]]) %>% 
    clearGroup(c("selectedMsoa", "selectedLad")) %>% 
    showGroup(c("ladBase", "groupBase", "msoa"))
  
}
