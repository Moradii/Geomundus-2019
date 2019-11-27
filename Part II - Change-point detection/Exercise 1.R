##########################################################
##########################################################
########################################################## Exercise 1
##########################################################
##########################################################

############################# call libraries
library(trend)
library(ecp)
#############################
set.seed(12345)

#############################
#############################
############################# normally-distributed data
#############################
#############################

# Simulate 400 normally-distributed, average 0 and standard deviation 1, vectors of length 168
Z <- replicate(400,rnorm(168),simplify = FALSE) 

# Apply Mann-Kendall to normally distributed vectors
mk.Z <- lapply(X=1:length(Z), function(i){
  mk.test(Z[[i]]) 
})

# Extract p-values
mk.Z.pv <- unlist(lapply(X=1:length(Z), function(i){
  mk.Z[[i]]$p.value
}))

# Probability of committing type I error
length(mk.Z.pv[mk.Z.pv<0.05])/length(Z)

# Apply E.divisive to normally distributed vectors
e.div <- lapply(X=1:length(Z), function(i){
  e.divisive(matrix(Z[[i]],ncol = 1),sig.lvl = 0.05)
})

# Extract those with change-points
e.div.est <- unlist(lapply(X=1:length(Z), function(i){
  length(e.div[[i]]$estimates)
}))

# Probability of committing type I error
length(e.div.est[e.div.est>2])/length(Z)

# Divide the normally distributed data into two groups
Z1 <- Z[1:200]

# Make an artificial change of magnitude 0.5 at time 21
Z1.changed <- lapply(X=1:200, function(i){
  c(Z1[[i]][1:20],Z1[[i]][21:168]+0.5)
})

plot(Z[[1]],ylab="",type="l",xlab="TIME",lwd=2)
points(Z1.changed[[1]],ylab="",col=2,type="l",lwd=2)

# Apply Mann-Kendall to Z1
mk.Z1.changed <- lapply(X=1:length(Z1.changed), function(i){
  mk.test(Z1.changed[[i]])
})
# Extract p-values
mk.Z1.changed.pv <- unlist(lapply(X=1:length(Z1.changed), function(i){
  mk.Z1.changed[[i]]$p.value
}))

# Emprical power
length(mk.Z1.changed.pv[mk.Z1.changed.pv<0.05])/length(Z1.changed)


# Apply E.divisive to Z1
e.div.Z1.changed <- lapply(X=1:length(Z1.changed), function(i){
  e.divisive(matrix(Z1.changed[[i]],ncol = 1),sig.lvl = 0.05)
})
# Extract those with change-point
e.div.Z1.changed.est <- unlist(lapply(X=1:length(Z1.changed), function(i){
  length(e.div.Z1.changed[[i]]$estimates)
}))

# Emprical power
length(e.div.Z1.changed.est[e.div.Z1.changed.est>2])/length(Z1.changed)


# Second group
Z2 <- Z[201:400]
# Make an artificial change of magnitude 0.5 at time 81
Z2.changed <- lapply(X=1:200, function(i){
  c(Z2[[i]][1:80],Z2[[i]][81:168]+.5)
})

plot(Z[[201]],ylab="",type="l",xlab="TIME",lwd=2)
points(Z2.changed[[1]],ylab="",col=2,type="l",lwd=2)

# Apply Mann-Kendall to Z2
mk.Z2.changed <- lapply(X=1:length(Z2.changed), function(i){
  mk.test(Z2.changed[[i]])
})

mk.Z2.changed.pv <- unlist(lapply(X=1:length(Z2.changed), function(i){
  mk.Z2.changed[[i]]$p.value
}))
# Emprical power
length(mk.Z2.changed.pv[mk.Z2.changed.pv<0.05])/length(Z2.changed)

# Apply E.divisive to Z2
e.div.Z2.changed <- lapply(X=1:length(Z2.changed), function(i){
  e.divisive(matrix(Z2.changed[[i]],ncol = 1),sig.lvl = 0.05)
})

e.div.Z2.changed.est <- unlist(lapply(X=1:length(Z2.changed), function(i){
  length(e.div.Z2.changed[[i]]$estimates)
}))
# Emprical power
length(e.div.Z2.changed.est[e.div.Z2.changed.est>2])/length(Z2.changed)



#############################
#############################
############################# Autoregressive
#############################
#############################

# Simulate 400 autoregressive time series of parameter 0.8, each of length 168
Z.ar <- replicate(400,arima.sim(168,model = list(ar=0.8)),simplify = FALSE) 

# Apply Mann-Kendall to normally distributed vectors
mk.Z.ar <- lapply(X=1:length(Z.ar), function(i){
  mk.test(Z.ar[[i]]) 
})

# Extract p-values
mk.Z.ar.pv <- unlist(lapply(X=1:length(Z.ar), function(i){
  mk.Z.ar[[i]]$p.value
}))

# Probability of committing type I error
length(mk.Z.ar.pv[mk.Z.ar.pv<0.05])/length(Z.ar)

# Apply E.divisive to normally distributed vectors
e.div.ar <- lapply(X=1:length(Z.ar), function(i){
  e.divisive(matrix(Z.ar[[i]],ncol = 1),sig.lvl = 0.05)
})

# Extract those with change-points
e.div.ar.est <- unlist(lapply(X=1:length(Z.ar), function(i){
  length(e.div.ar[[i]]$estimates)
}))

# Probability of committing type I error
length(e.div.ar.est[e.div.ar.est>2])/length(Z.ar)
