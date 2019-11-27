library(RGISTools)

Regions<- raster::getData('GADM', country='Spain', level=2,path='./GeoMundus')
class(Regions)
castellon<-subset(Regions,NAME_2=="Castellón")
spplot(castellon)
castellon<-st_as_sf(castellon)
castellon<-castellon[1]
plot(castellon)


sres<-modSearch("MOD11A2",
                resType = "browseurl",
                region=castellon,
                startDate=as.Date("2001-01-01"),
                endDate=as.Date("2018-12-31"))
modGetDates(sres)
library(mapview)
modPreview(sres,dates=as.Date("2001-01-01"))+mapview(castellon)

sres<-modSearch("MOD11A2",
                resType = "url",
                region=castellon,
                startDate=as.Date("2001-01-01"),
                endDate=as.Date("2018-12-31"))
modDownload(sres,
            AppRoot = './Geomundus-2019/Data/Castellon/MOD11A2',
            username = "geomundus2019",
            password = "Geomundus2019",
            bFilter=c("LST_Day_1KM",
                      "LST_Night_1KM"),
            extract.tif = T)


modMosaic(src='./Geomundus-2019/Data/Castellon/MOD11A2/tif',
          AppRoot ='./Geomundus-2019/Data/Castellon/MOD11A2',
          out.name = "Castellon",
          region=castellon)

lst.day.castellon.tif<-list.files('./Geomundus-2019/Data/Castellon/MOD11A2/Castellon',
                                  full.names = TRUE,
                                  pattern = "Day_1km\\.tif$",
                                  recursive=T)
lst.day.castellon<-stack(lst.day.castellon.tif)
lst.day.castellon<-readAll(lst.day.castellon)
lst.day.castellon<-lst.day.castellon*0.02
lst.day.castellon.monthly<-genCompositions(lst.day.castellon,by="month",fun=mean)
lst.day.castellon.monthly<-readAll(lst.day.castellon.monthly)
save(list=c("lst.day.castellon.monthly"),file ="lst_day_castellon_monthly.RDada")

lst.nigth.castellon.tif<-list.files('./Geomundus-2019/Data/Castellon/MOD11A2/Castellon',
                                    full.names = TRUE,
                                    pattern = "Night_1km\\.tif$",
                                    recursive=T)
lst.nigth.castellon<-stack(lst.nigth.castellon.tif)
lst.nigth.castellon<-readAll(lst.nigth.castellon)
lst.nigth.castellon<-lst.nigth.castellon*0.02
lst.nigth.castellon.monthly<-genCompositions(lst.nigth.castellon,by="month",fun=mean)
lst.nigth.castellon.monthly<-readAll(lst.nigth.castellon.monthly)
save(list=c("lst.nigth.castellon.monthly"),file ="lst_nigth_castellon_monthly.RDada")
