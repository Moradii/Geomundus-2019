library(RGISTools)
library(sf)
##############################
Regions<- raster::getData('GADM', country='Portugal', level=2,path='D:/')
class(Regions)
lisbon <- subset(Regions,NAME_2=="Lisboa")

lisbon <- st_as_sf(lisbon)
lisbon <- lisbon[1]
plot(lisbon)
