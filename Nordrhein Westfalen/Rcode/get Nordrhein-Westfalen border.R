library(RGISTools)
library(sf)
##############################
Regions<- raster::getData('GADM', country='Germany', level=2,path='D:/')
class(Regions)
Regions@data$NAME_1
Regions@data$NAME_2
Nordrhein_Westfalen <- subset(Regions,NAME_1=="Nordrhein-Westfalen")

save(Nordrhein_Westfalen,file = "Nordrhein.RData")

Nordrhein_Westfalen <- st_as_sf(Nordrhein_Westfalen)
Nordrhein_Westfalen<- Nordrhein_Westfalen[1]
plot(Nordrhein_Westfalen)
