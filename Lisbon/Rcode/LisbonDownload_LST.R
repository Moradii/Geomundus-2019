library(RGISTools)

Regions <- raster::getData('GADM', country='Portugal', level=2,path='D:/UPNA/GeoMundus2019')
class(Regions)
Lisbon <-subset(Regions,NAME_2=="Lisboa")
spplot(Lisbon)
Lisbon <- st_as_sf(Lisbon)
Lisbon <- Lisbon[1]
plot(Lisbon)


sres <- modSearch("MOD11A2",
                resType = "browseurl",
                region=Lisbon,
                startDate=as.Date("2001-01-01"),
                endDate=as.Date("2018-12-31"))
modGetDates(sres)
library(mapview)
modPreview(sres,dates=as.Date("2001-01-01"))+mapview(Lisbon)

sres <- modSearch("MOD11A2",
                resType = "url",
                region=Lisbon,
                startDate=as.Date("2001-01-01"),
                endDate=as.Date("2018-12-31"))
modDownload(sres,
            AppRoot = 'D:/UPNA/GeoMundus2019/lisbon',
            username = "geomundus2019",
            password = "Geomundus2019",
            bFilter=c("LST_Day_1KM",
                      "LST_Night_1KM"),
            extract.tif = T)


modMosaic(src='D:/UPNA/GeoMundus2019/lisbon/tif',
          AppRoot ='D:/UPNA/GeoMundus2019/lisbon',
          out.name = "lisbon",
          region = Lisbon)

lst.day.lisbon.tif <- list.files('D:/UPNA/GeoMundus2019/lisbon/lisbon',
                                  full.names = TRUE,
                                  pattern = "Day_1km\\.tif$",
                                  recursive=T)

lst.day.lisbon <- stack(lst.day.lisbon.tif)
lst.day.lisbon <- readAll(lst.day.lisbon)
lst.day.lisbon <- lst.day.lisbon*0.02
lst.day.lisbon.monthly <- genCompositions(lst.day.lisbon,by="month",fun=mean)
lst.day.lisbon.monthly <- readAll(lst.day.lisbon.monthly)

save(list=c("lst.day.lisbon.monthly"),file ="lst.day.lisbon.monthly.RData")

lst.nigth.lisbon.tif <- list.files('D:/UPNA/GeoMundus2019/lisbon/lisbon',
                                    full.names = TRUE,
                                    pattern = "Night_1km\\.tif$",
                                    recursive=T)
lst.nigth.lisbon <- stack(lst.nigth.lisbon.tif)
lst.nigth.lisbon <- readAll(lst.nigth.lisbon)
lst.nigth.lisbon <- lst.nigth.lisbon*0.02
lst.nigth.lisbon.monthly <- genCompositions(lst.nigth.lisbon,by="month",fun=mean)
lst.nigth.lisbon.monthly <- readAll(lst.nigth.lisbon.monthly)
save(list=c("lst.nigth.lisbon.monthly"),file ="lst.nigth.lisbon.monthly.RData")
