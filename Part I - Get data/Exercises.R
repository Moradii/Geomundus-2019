###############################################################################
# GEOMUNDUS 2019 - EXERCISES
###############################################################################
# Montesino-SanMartin, M., Perez-Goya, U., Moradi, M., Ugarte, M.D., Militino, A.F.
# UPNA

library(RGISTools)

###############################################################################
# EXERCISE 1: ROI
###############################################################################
# ROI from GADM
germany <- getData('GADM', country = "Germany", level = 2)
nordrhein <- subset(germany, NAME_1 == "Nordrhein-Westfalen")
# Visualization of ROI (interactive)
tmap_mode("view")
tmap_leaflet(tm_shape(nordrhein) +
             tm_polygons(col = "red") +
             tm_view(set.view = 4))

###############################################################################
# EXERCISE 2: SEARCH
###############################################################################
# Search LST images over Nordrhein-Westfalen from 2001 to 2018 
sres.lst <- modSearch(product = "MOD11A2",
                      region = nordrhein,
                      dates = seq(as.Date("2001-01-01"),
                                  as.Date("2018-12-31"),1))
# Total number:
length(sres.lst)
# Tile ID number:
sres.tileid <- unique(modGetPathRow(sres.lst))
sres.tileid
# "h18v03" 
sres.dates <- unique(modGetDates(sres.lst))
sres.dates[1:4]
# [1] "2001-01-01" "2001-01-09" "2001-01-17" "2001-01-25"
length(sres.dates)
# [1] 827

# Questions:
# (a) How many images did you find? 827
# (b) How many tiles intersect our Nordrhein-Westfalen? One, the h18v03
# (c) What is the temporal frequency? One image every 8 days

###############################################################################
# EXERCISE 3: DOWNLOAD
###############################################################################
wdir.lst <- file.path("./", "exercises", "lst")
modDownload(searchres = sres.lst[1],
            AppRoot = wdir.lst,
            username = "geomundus2019",
            password = "Geomundus2019",
            extract.tif = TRUE,
            bFilter = "LST_Day_1km",
            raw.rm = TRUE)

# ./exercises/lst/tif: 1 image (2.75 MB)

###############################################################################
# EXERCISE 4: MOSAIC
###############################################################################
wdir.lst.tif <- file.path(wdir.lst, "tif")
modMosaic(src = wdir.lst.tif,
          region = nordrhein,
          out.name = "nordrhein",
          AppRoot = wdir.lst)

# ./exercises/lst/tif: one image (2.75 MB)
# ./exercises/lst/nordrhein: one image (125 KB)

###############################################################################
# EXERCISE 5: IMPORT AND SHOW
###############################################################################
wdir.lst.mos <- file.path(wdir.lst, "nordrhein")
files.lst <- list.files(wdir.lst.mos, full.names = TRUE, recursive = TRUE)
imgs.lst <- stack(files.lst)

# From the MODIS MOD11A2 data product website
# Scaling factor for layer LST_Day_1km, 0.02
# Check: https://lpdaac.usgs.gov/products/mod11a2v006/
scale.factor <- 0.02
imgs.lst <- imgs.lst * scale.factor
genPlotGIS(r = imgs.lst,
           region = nordrhein,
           tm.raster.r.alpha = 0.5)
