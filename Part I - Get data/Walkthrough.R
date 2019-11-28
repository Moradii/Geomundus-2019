###############################################################################
# GEOMUNDUS 2019 - WALK-THROUGH
###############################################################################
# Montesino-SanMartin, M., Perez-Goya, U., Moradi, M., Ugarte, M.D., Militino, A.F.
# UPNA

library(RGISTools)

###############################################################################
# WALK-THROUGH 1: ROI
###############################################################################
# ROI from GADM
spain <- getData('GADM', country = "Spain", level = 2)
castellon <- subset(spain, NAME_2 == "Castellón")
# Visualization of ROI (interactive)
tmap_mode("view")
tmap_leaflet(
  tm_shape(castellon) +
    tm_polygons(col = "red") +
    tm_view(set.view = 4))

###############################################################################
# WALK-THROUGH 2: SEARCH
###############################################################################
# Search ndvi images over Nordrhein-Westfalen from 2001 to 2018 
sres.ndvi <- modSearch(product = "MOD13A2",
                       region = castellon,
                       dates = seq(as.Date("2001-01-01"),
                                   as.Date("2018-12-31"),1))
# Total number:
length(sres.ndvi)
# Tile ID number:
sres.tileid <- unique(modGetPathRow(sres.ndvi))
sres.tileid
# [1] "h18v05" "h17v04" "h17v05" "h18v04" 
sres.dates <- unique(modGetDates(sres.ndvi))
sres.dates[1:4]
# [1] "2001-01-01" "2001-01-17" "2001-02-02" "2001-02-18"
length(sres.dates)
# [1] 414

###############################################################################
# WALK-THROUGH 3: DOWNLOAD
###############################################################################
wdir.ndvi <- file.path("./", "exercises", "ndvi")
modDownload(searchres = sres.ndvi[1:4],
            AppRoot = wdir.ndvi,
            username = "geomundus2019",
            password = "Geomundus2019",
            extract.tif = TRUE,
            bFilter = "NDVI",
            raw.rm = TRUE)

# ./exercises/ndvi/tif: 4 images (11 MB)

###############################################################################
# WALK-THROUGH 4: MOSAIC
###############################################################################
wdir.ndvi.tif <- file.path(wdir.ndvi, "tif")
modMosaic(src = wdir.ndvi.tif,
          region = castellon,
          out.name = "castellon",
          AppRoot = wdir.ndvi)

# ./exercises/ndvi/tif: 4 images (11 MB)
# ./exercises/ndvi/castellon: one image (36.2 KB)

###############################################################################
# WALK-THROUGH 5: IMPORT AND SHOW
###############################################################################
wdir.ndvi.mos <- file.path(wdir.ndvi, "castellon")
files.ndvi <- list.files(wdir.ndvi.mos, full.names = TRUE, recursive = TRUE)
imgs.ndvi <- stack(files.ndvi)

# From the MODIS MOD13A2 data product website
# Scaling factor for layer NDVI, 0.0001
# Check: https://lpdaac.usgs.gov/products/mod13a2v006/
scale.factor <- 0.0001
imgs.ndvi <- imgs.ndvi * scale.factor
genPlotGIS(r = imgs.ndvi,
           region = castellon,
           tm.raster.r.alpha = 0.5)
