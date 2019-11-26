###################################################################
################################################################### Exercise 2
###################################################################

#################################################### Load R packages
library(repmis)
library(remote)
library(trend)
library(ecp)
library(gimms)
library(plotKML)
library(sp)

#################################################### load castellon lst night

source_data("https://github.com/Moradii/Geomundus-2019/blob/master/Castellon/Data/lst_nigth_castellon_monthly.RData?raw=True")

#################################################### load castellon border

source_data("https://github.com/Moradii/Geomundus-2019/blob/master/Castellon/Data/castellon_border.RData?raw=True")

#################################################### project castellon border to the same ref system as lst night

castellon <- spTransform(castellon, CRS("+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs"))

#################################################### Mask lst night to the border of castellon

lst.night <- mask(lst.nigth.castellon.monthly,castellon)

#################################################### change the names of monthly images
Sys.setlocale("LC_ALL","English")
library(zoo)
names(lst.night) <- as.yearmon(seq(as.Date("2001/1/1"), as.Date("2018/12/31"), "month"))

#################################################### plot data
spplot(lst.night[[1:12]])
boxplot(lst.night[[1:36]],xaxt='n',main="LST night 2001-03")

#################################################### deseason data

lst.night.d <- deseason(lst.night) #deseason data
names(lst.night.d) <- as.yearmon(seq(as.Date("2001/1/1"), as.Date("2018/12/31"), "month"))
boxplot(lst.night.d[[1:36]],xaxt='n',main="deseasoned LST night 2001-03")

#################################################### make aggregation
cas_n <- aggregate(lst.night.d,fac=4,mean)
spplot(cas_n[[1:12]])
boxplot(cas_n[[1:36]],xaxt='n',main="aggregated deseasoned LST night 2001-03")

#################################################### calculate PACF for all pixel time series to check temporal autocorrelation
pacfs <- lapply(X=1:ncell(cas_n), function(i){
  x <- cas_n[i]
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

#################################################### present PACF's as an image to see where it is higher/lower
pacf.night.image <- cas_n[[1]]
pacf.night.image@data@values <- pacf_coef
ckey <- list(labels=list(cex=1.5))
spplot(pacf.night.image,colorkey=ckey,scales=list(draw=T,cex=1))


#################################################### Calculate Moran I for all monthly images
moran <- unlist(
  lapply(X=1:nlayers(cas_n), function(i){
    Moran(cas_n[[i]])
  })
)

#################################################### check Moran as time series
plot(moran,type="l")
summary(moran)
pacf(moran)

cas_n@data@names[which.max(moran)]

#################################################### Mann-Kendall
par(mfrow=c(1,1))
mk <- significantTau(cas_n,prewhitening = F,p=0.001)
cells.mk <- Which(mk,cells=T)
# pacf_coef[cells.trd1]
mk.len <- length(cells.mk)  
plot(mk)
plot(castellon,add=TRUE)

#################################################### apply e.divisive to detected pixels by Mann-Kendall
e.div <- list()

for (i in 1:mk.len) {
  e.div[[i]] <- e.divisive(as.matrix(as.numeric(cas_n[cells.mk[i]]),ncol=1),sig.lvl=.001)$estimates
  }
ln <- unlist(lapply(e.div,length))


mk.night.div <- mk
mk.night.div@data@values[-c(cells.mk[which(ln>2)])] <- NA
plot(mk.night.div)
plot(castellon,add=TRUE)
plotKML(mk.night.div)
