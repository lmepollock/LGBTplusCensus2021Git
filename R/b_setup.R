library(tidyverse)
library(htmltools)
library(leaflet)
library(sf)
library(viridis)

msoa <- st_read("data/dataset.gpkg") 

background <- st_read("data/country/country-background-wgs84.shp")%>% 
  st_transform("WGS84")

lad <- sf::st_read("data/msoa_shp/lad_hex.shp")%>% 
  st_transform("WGS84")
group <- sf::st_read("data/msoa_shp/group_hex.shp")%>% 
  st_transform("WGS84")

varnames <- c("all_lgb_plus",
              "gay_or_lesbian",
              "bisexual_and_other",
              "all_diff_id",
              "trans_mw",
              "other_id",
              "different_unanswered")

msoa <- mutate(msoa, across(all_of(varnames), ~.x*100))

# use "simple" Coord Ref System (i.e. xy plane)
crs <- leaflet::leafletCRS(crsClass = "L.CRS.Simple")

#pal <- inferno(6)



pal <- list(
  all_lgb_plus = inferno(6) ,
  gay_or_lesbian = inferno(6),
  bisexual_and_other = inferno(6),
  all_diff_id = inferno(6),
  different_unanswered = inferno(6),
  other_id = inferno(7),
  trans_mw = inferno(7)
)


bins <- list(
  all_lgb_plus = c(0, 0.02, 0.04, 0.06, 0.08, 0.1, 1) *100 ,
  gay_or_lesbian = c(0, 0.01, 0.02, 0.03, 0.04, 0.05, 1)*100,
  bisexual_and_other = c(0, 0.01, 0.02, 0.03, 0.04, 0.05, 1)*100,
  all_diff_id = c(0, 0.005,0.01, 0.015, 0.02, 0.025, 1)*100,
  different_unanswered = c(0, 0.005,0.01, 0.015, 0.02, 0.025, 1)*100,
  other_id = c(0, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 1)*100,
  trans_mw = c(0, 0.001, 0.002, 0.003, 0.004, 0.005, 0.006, 1)*100
)

legColours <- list(
  all_lgb_plus = c("0 - 2%", "2 - 4%", "4 - 6%", "6 - 8%", "8 - 10%", ">10%"),
  gay_or_lesbian = c("0 - 1%", "1 - 2%", "2 - 3%", "3 - 4%", "4 - 5%", ">5%"),
  bisexual_and_other = c("0 - 1%", "1 - 2%", "2 - 3%", "3 - 4%", "4 - 5%", ">5%"),
  all_diff_id = c("0 - 0.5%", "0.5 - 1%", "1 - 1.5%", "1.5 - 2%", "2 - 2.5%", ">2.5%"),
  different_unanswered = c("0 - 0.5%", "0.5 - 1%", "1 - 1.5%", "1.5 - 2%", "2 - 2.5%", ">2.5%"),
  other_id = c("0 - 0.1%", "0.1 - 0.2%", "0.2 - 0.3%", "0.3 - 0.4%", "0.4 - 0.5%", "0.5 - 0.6%", ">0.6%"),
  trans_mw = c("0 - 0.1%", "0.1 - 0.2%", "0.2 - 0.3%", "0.3 - 0.4%", "0.4 - 0.5%", "0.5 - 0.6%", ">0.6%")
)