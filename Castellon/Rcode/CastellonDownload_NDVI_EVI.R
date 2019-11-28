library(RGISTools)

Regions<- raster::getData('GADM', country='Spain', level=2,path='./Geomundus-2019/Data/Castellon')
class(Regions)
castellon<-subset(Regions,NAME_2=="Castell?n")
castellon<-st_as_sf(castellon)
castellon<-castellon[1]
plot(castellon)


sres<-modSearch("MOD13A3",
                resType = "browseurl",
                region=castellon,
                startDate=as.Date("2001-01-01"),
                endDate=as.Date("2018-12-31"))
modGetDates(sres)
library(mapview)

sres<-modSearch("MOD13A3",
                resType = "url",
                region=castellon,
                startDate=as.Date("2001-01-01"),
                endDate=as.Date("2018-12-31"))
modDownload(sres,
            AppRoot = './Geomundus-2019/Data/Castellon/MOD13A3',
            username = "geomundus2019",
            password = "Geomundus2019",
            bFilter=c("NDVI",
                      "EVI"),
            extract.tif = T)


modMosaic(src='./Geomundus-2019/Data/Castellon/MOD13A3/tif',
          AppRoot ='./Geomundus-2019/Data/Castellon/MOD13A3',
          out.name = "Castellon",
          overwrite = T,
          region=castellon)


ndvi.castellon.tif<-list.files('./Geomundus-2019/Data/Castellon/MOD13A3/Castellon',
                                  full.names = TRUE,
                                  pattern = "NDVI\\.tif$",
                                  recursive=T)
ndvi.castellon<-stack(ndvi.castellon.tif)
ndvi.castellon<-readAll(ndvi.castellon)

ndvi.castellon.monthly<-ndvi.castellon*0.0001
ndvi.castellon.monthly<-readAll(ndvi.castellon.monthly)
save(list=c("ndvi.castellon.monthly"),file ="ndvi_castellon_monthly.RDada")


evi.castellon.tif<-list.files('./Geomundus-2019/Data/Castellon/MOD13A3/Castellon',
                                   full.names = TRUE,
                                   pattern = "EVI\\.tif$",
                                   recursive=T)
evi.castellon<-stack(evi.castellon.tif)
evi.castellon<-readAll(evi.castellon)

evi.castellon.monthly<-evi.castellon*0.0001
evi.castellon.monthly<-readAll(evi.castellon.monthly)
save(list=c("evi.castellon.monthly"),file ="evi_castellon_monthly.RDada")


