## Retrieve and process satellite images time series towards data analysis in R

Geomundus-2019, November 30, Manuel Montesino and Mehdi Moradi

## Abstract

Satellite images are valuable sources to monitor the changes happening in the earth's surface patterns as well as dynamics. However, the analyses of such images often require a long series of remotely-sensed data. In two hands-on sessions, we first cover the use of the R package RGISTools to facilitate the handling of satellite images time series from major satellite programs, such as Landsat, MODIS, and Sentinel, covering in a comprehensive manner the retrieval, and customizing and processing satellite images. Having retrieved and processed satellite images time series of e.g. land surface temperature (LST) and/or vegetation indices from MODIS, we then review some of the most considered change-point and trend detection methods, and make use of them to discuss the areas where have faced changes over time together with the corresponding time of change for some provinces/cities in Europe.

## Workshop program

15:15 - 16:15:

16:15 - 17:15: Introduction to trend and change-point detection through different showcases, power of test and type I error, satellite images time series analysis + exercises (Mehdi)

## Notes to keep in mind

1. Install the latest versions of [R](https://cran.r-project.org/) and [RStudio](https://rstudio.com/products/rstudio/download/)

2. Packages used in part 1:

3. Packages used in part 2: [trend](https://cran.r-project.org/web/packages/trend/index.html), [ecp](https://cran.r-project.org/web/packages/ecp/index.html), [remote](https://cran.r-project.org/web/packages/remote/index.html),
[gimms](https://cran.r-project.org/web/packages/gimms/index.html),
[repmis](https://cran.r-project.org/web/packages/repmis/index.html),
[plotKML](https://cran.r-project.org/web/packages/plotKML/index.html),
[sp](https://cran.r-project.org/web/packages/sp/index.html),
[zoo](https://cran.r-project.org/web/packages/zoo/index.html),
[raster](https://cran.r-project.org/web/packages/raster/index.html)