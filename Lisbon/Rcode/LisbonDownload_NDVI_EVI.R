library(RGISTools)

Regions <- raster::getData('GADM', country='Portugal', level=2, path='./')
class(Regions)
Lisbon <-subset(Regions,NAME_2=="Lisboa")
spplot(Lisbon)
Lisbon <- st_as_sf(Lisbon)
Lisbon <- Lisbon[1]
plot(Lisbon)


sres <- modSearch("MOD13A2",
                  resType = "browseurl",
                  region=Lisbon,
                  startDate=as.Date("2001-01-01"),
                  endDate=as.Date("2018-12-31"))
modGetDates(sres)
library(mapview)

sres <- modSearch("MOD13A2",
                  resType = "url",
                  region=Lisbon,
                  startDate=as.Date("2001-01-01"),
                  endDate=as.Date("2018-12-31"))
modDownload(sres,
            AppRoot = './Lisbon/Data',
            username = "geomundus2019",
            password = "Geomundus2019",
            bFilter = c("NDVI",
                      "EVI"),
            extract.tif = T)


modMosaic(src='./Lisbon/Data/tif',
          AppRoot ='D:/UPNA/GeoMundus2019/lisbon',
          out.name = "lisbon",
          overwrite = TRUE,
          region=Lisbon)


ndvi.lisbon.tif <- list.files('E:/GeoMundus/MOD13A3/lisbon',
                                  full.names = TRUE,
                                  pattern = "NDVI\\.tif$",
                                  recursive=T)
ndvi.lisbon<-stack(ndvi.lisbon.tif)
ndvi.lisbon<-readAll(ndvi.lisbon)

ndvi.lisbon.monthly<-ndvi.lisbon*0.0001
ndvi.lisbon.monthly<-readAll(ndvi.lisbon.monthly)
save(list=c("ndvi.lisbon.monthly"),file ="ndvi_lisbon_monthly.RData")


evi.lisbon.tif<-list.files('E:/GeoMundus/MOD13A3/lisbon',
                                   full.names = TRUE,
                                   pattern = "EVI\\.tif$",
                                   recursive=T)
evi.lisbon<-stack(evi.lisbon.tif)
evi.lisbon<-readAll(evi.lisbon)

evi.lisbon.monthly<-evi.lisbon*0.0001
evi.lisbon.monthly<-readAll(evi.lisbon.monthly)
save(list=c("evi.lisbon.monthly"),file ="evi_lisbon_monthly.RData")


