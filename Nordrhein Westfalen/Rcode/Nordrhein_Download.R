## ------------------------------------------------------------------------
library(mapview)
roi.de <- getData(name = "GADM", country = "Germany", level = 2)
roi.nw <- subset(roi.de, NAME_1 == "Nordrhein-Westfalen")
tmap_mode("view")
tm_shape(roi.nw) +
  tm_polygons()


## ----searchpv------------------------------------------------------------
library(RGISTools)
sres.mod13 <- modSearch(product ="MOD13A3",
                        region = roi.nw,
                        startDate = as.Date("2001-01-01"),
                        endDate = as.Date("2018-12-31"),
                        resType = "browseurl")


## ----preliminaries-------------------------------------------------------
tiles <- unique(modGetPathRow(sres))
tiles
no.imgs <- length(sres)
no.imgs
dates <- unique(modGetDates(sres))
dates[1:3]


## ----preview-------------------------------------------------------------
modPreview(sres, 2)


## ----search--------------------------------------------------------------
sres.mod13 <- modSearch(product ="MOD13A3",
                        region = roi.nw,
                        startDate = as.Date("2001-01-01"),
                        endDate = as.Date("2018-12-31"))

sres.mod11 <- modSearch(product ="MOD11A2",
                        region = roi.nw,
                        startDate = as.Date("2001-01-01"),
                        endDate = as.Date("2018-12-31"))


## ----download------------------------------------------------------------
wdir <- "D:/geomundus"
wdir.mod13 <- file.path(wdir, "MOD13A3")
modDownload(searchres = sres.mod13,
            AppRoot = wdir.mod13,
            username = "geomundus2019",
            password = "Geomundus2019",
            extract.tif = TRUE,
            bFilter = c("NDVI", "EVI"))

wdir.mod11 <- file.path(wdir, "MOD11A2")
modDownload(searchres = sres.mod11,
            AppRoot = wdir.mod11,
            username = "geomundus2019",
            password = "Geomundus2019",
            extract.tif = TRUE,
            bFilter = c("LST_Day_1KM", "LST_Night_1KM"))


## ------------------------------------------------------------------------
wdir.mod13.tif <- file.path(wdir.mod13, "tif")
modMosaic(src = wdir.mod13.tif,
          region = roi.nw,
          out.name = "Nordrhein_Westfalen",
          AppRoot = wdir.mod13)

wdir.mod11.tif <- file.path(wdir.mod11, "tif")
modMosaic(src = wdir.mod11.tif,
          region = roi.nw,
          out.name = "Nordrhein_Westfalen",
          AppRoot = wdir.mod11)


## ------------------------------------------------------------------------
wdir.mod11.mos <- file.path(wdir.mod11, "Nordrhein_Westfalen")
files.mod11.lstday <- list.files(wdir.mod11.mos,
                              recursive = T,
                              full.names = T,
                              pattern = "LST_Day_1km")
imgs.mod11.lstday <- stack(files.mod11.lstday)
imgs.mod11.lstday.out <- file.path(wdir.mod11, "LST_Day")
genCompositions(imgs.mod11.lstday,
                by = "month",
                fun = mean,
                AppRoot = imgs.mod11.lstday.out)


files.mod11.lstnight <- list.files(wdir.mod11.mos,
                              recursive = T,
                              full.names = T,
                              pattern = "LST_Night_1km")
imgs.mod11.lstnight <- stack(files.mod11.lstnight)
imgs.mod11.lstnight.out <- file.path(wdir.mod11, "LST_Night")
genCompositions(imgs.mod11.lstnight,
                by = "month",
                fun = mean,
                AppRoot = imgs.mod11.lstnight.out)




## ------------------------------------------------------------------------
files.mod13.ndvi <- list.files(wdir.mod13.mos,
                               recursive = T,
                               full.names = T,
                               pattern = "NDVI")
ndvi.nordrhein.monthly <- stack(files.mod13.ndvi)
ndvi.nordrhein.monthly <- readAll(ndvi.nordrhein.monthly)
ndvi.nordrhein.monthly <- ndvi.nordrhein.monthly *0.0001
file.path.out <- file.path(wdir,"ndvi_nordrhein_monthly.RData")
save(list = "ndvi.nordrhein.monthly", file = file.path.out)

files.mod13.evi <- list.files(wdir.mod13.mos,
                               recursive = T,
                               full.names = T,
                               pattern = "EVI")
evi.nordrhein.monthly <- stack(files.mod13.evi)
evi.nordrhein.monthly <- readAll(evi.nordrhein.monthly)
evi.nordrhein.monthly <- evi.nordrhein.monthly *0.0001
file.path.out <- file.path(wdir,"evi_nordrhein_monthly.RData")
save(list = "evi.nordrhein.monthly", file = file.path.out)


files.mod11.lst.day <- list.files(imgs.mod11.lstday.out,
                               recursive = T,
                               full.names = T,
                               pattern = "\\.tif$")
lst.day.nordrhein.monthly <- stack(files.mod11.lst.day)
lst.day.nordrhein.monthly <- readAll(lst.day.nordrhein.monthly)
lst.day.nordrhein.monthly <- lst.day.nordrhein.monthly *0.02
file.path.out <- file.path(wdir,"lst_day_nordrhein_monthly.RData")
save(list = "lst.day.nordrhein.monthly", file = file.path.out)

files.mod11.lst.night <- list.files(imgs.mod11.lstnight.out,
                               recursive = T,
                               full.names = T,
                               pattern = "\\.tif$")
lst.night.nordrhein.monthly <- stack(files.mod11.lst.night)
lst.night.nordrhein.monthly <- readAll(lst.night.nordrhein.monthly)
lst.night.nordrhein.monthly <- lst.night.nordrhein.monthly *0.02
file.path.out <- file.path(wdir,"lst_night_nordrhein_monthly.RData")
save(list = "lst.night.nordrhein.monthly", file = file.path.out)

