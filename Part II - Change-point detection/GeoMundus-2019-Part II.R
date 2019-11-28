## ----setup, include=FALSE---------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----fig.height = 7,out.width = '95%',fig.align = "center"------------------------
set.seed(1234)
x <- rnorm(200)
y <- arima.sim(n=200,model = list(ar=0.8))
t <- seq(1,4,length.out = 200)
w <- x+t
z <- c(x[1:60],x[61:200]+2)

par(mfrow=c(2,2))
ts.plot(x,main="randomly normally-distributed");ts.plot(y,main="timely correlated");ts.plot(w,main="upward trend");ts.plot(z,main="abrupt change")


## ----fig.height = 7,out.width = '95%',fig.align = "center"------------------------
set.seed(1234)
x <- rnorm(200)
t <- seq(1,4,length.out = 100)
w <- x+c(t,rev(t))
w1 <- x+c(t,rep(t[100],100))
z <- c(x[1:60],x[61:120]+2,x[121:200]-2)
z1 <- sin(c(1:100))+runif(100,-0.1,0.1)

par(mfrow=c(2,2))
ts.plot(w,main="trend upward/downward");ts.plot(w1,main="trend upward/stable");ts.plot(z,main="abrupt change");ts.plot(z1,main="seasonality")


## ----fig.height = 7,out.width = '50%',fig.align = "center",message=FALSE,warning=FALSE----
library(gplots)
set.seed(123)
x <- rnorm(200)
y <- c(1:200)
z <- c(x[1:100],x[101:200]+2)
ts.plot(z)
lines(lowess(y,z,f=.8), col="red",lwd=2)
lines(lowess(y[1:100],z[1:100],f=.8), col="blue",lwd=4)
lines(lowess(y[101:200],z[101:200],f=.8), col="gold",lwd=4)



## ----message=FALSE,warning=FALSE--------------------------------------------------
library(trend)
set.seed(123)
x <- rnorm(200)
mk.test(x)


## ----message=FALSE,warning=FALSE--------------------------------------------------
z <- c(x[1:100],x[101:200]+2)
mk.test(z)


## ----message=FALSE,warning=FALSE--------------------------------------------------
library(ecp)
e.divisive(matrix(x,ncol = 1),sig.lvl=.05)
e.divisive(matrix(z,ncol = 1),sig.lvl=.05)


## ----message=FALSE,warning=FALSE--------------------------------------------------
set.seed(1234)
x.ar <- arima.sim(168,model = list(ar=0.8))
mk.test(x.ar)
e.divisive(matrix(x.ar,ncol = 1),sig.lvl=.05)


## ----message=FALSE,warning=FALSE--------------------------------------------------
library(repmis)
library(remote)
library(trend)
library(ecp)
library(gimms)
library(plotKML)
library(sp)
library(raster)
library(tmap)


## ----message=FALSE,warning=FALSE--------------------------------------------------

source_data("https://github.com/Moradii/Geomundus-2019/blob/master/Castellon/Data/lst_day_castellon_monthly.RData?raw=True")

source_data("https://github.com/Moradii/Geomundus-2019/blob/master/Castellon/Data/castellon_border.RData?raw=True")

castellon <- spTransform(castellon, CRS("+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs"))

lst.day <- mask(lst.day.castellon.monthly,castellon)
Sys.setlocale("LC_ALL","English")
library(zoo)
names(lst.day) <- as.yearmon(seq(as.Date("2001/1/1"), as.Date("2018/12/31"), "month"))



## ----fig.height = 7,out.width = '100%',fig.align = "center",message=FALSE,warning=FALSE----
spplot(lst.day[[1:12]])
boxplot(lst.day[[1:36]],xaxt='n',main="LST day 2001 - 2003")

lst.day.d <- deseason(lst.day) #deseason data
names(lst.day.d) <- as.yearmon(seq(as.Date("2001/1/1"), as.Date("2018/12/31"), "month"))
boxplot(lst.day.d[[1:36]],xaxt='n',main="deseasoned LST day 2001 - 2003")

cas_d <- aggregate(lst.day.d,fac=4,mean)
spplot(cas_d[[1:12]])
boxplot(cas_d[[1:36]],xaxt='n',main="aggregated deseasoned LST day 2001 - 2003")

# check the temporal autocorrelation in data
pacfs <- lapply(X=1:ncell(cas_d), function(i){
  x <- cas_d[i]
  if(!anyNA(x)){return(pacf(x,plot = FALSE))}
  else{return(0)}
})
pacf_coef <- numeric()
for (i in 1:length(pacfs)) {
  if(class(pacfs[[i]])=="numeric"){pacf_coef[i] <- NA}
  else{pacf_coef[i] <- pacfs[[i]]$acf[1]}
}

mean(pacf_coef[!is.na(pacf_coef)])
summary(pacf_coef[!is.na(pacf_coef)])
par(mar=rep(4,4))
boxplot(pacf_coef[!is.na(pacf_coef)])

# display obtained PACF coefficient per pixel as an image
pacf.day.image <- cas_d[[1]]
pacf.day.image@data@values <- pacf_coef
ckey <- list(labels=list(cex=1.5))
spplot(pacf.day.image,colorkey=ckey,scales=list(draw=T,cex=1.4))

# check the spatial autocorrelation
moran <- unlist(
  lapply(X=1:nlayers(cas_d), function(i){
    Moran(cas_d[[i]])
  })
)
plot(moran,type="l")
summary(moran)

# check if there is temporal autocorrelation in obtained spatial autocorrelations
pacf(moran)
cas_d@data@names[which.max(moran)]

# we now apply the Mann-Kendall method to LST remote sensing data of Castellon
par(mfrow=c(1,1))
mk <- significantTau(cas_d,prewhitening = F,p=0.001)
cells.mk <- Which(mk,cells=T)
# pacf_coef[cells.trd1]
mk.len <- length(cells.mk)  
plot(mk)
plot(castellon,add=TRUE)

# apply the E.divisive method to all detected pixels with change/trend based on Mann-Kendall
e.div <- list()
for (i in 1:mk.len) {
  e.div[[i]] <- e.divisive(as.matrix(as.numeric(cas_d[cells.mk[i]]),ncol=1),sig.lvl=.001)$estimates
}
ln <- unlist(lapply(e.div,length))

# represent the pixels detected by both methods
mk.day.div <- mk
mk.day.div@data@values[-c(cells.mk[which(ln>2)])] <- NA
plot(mk.day.div)
plot(castellon,add=TRUE)

tmap_leaflet(tm_shape(mk.day.div) +
  tm_raster(alpha = 0.75) +
  tm_view(set.view = 8))

