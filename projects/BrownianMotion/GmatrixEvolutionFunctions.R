##A fun function for looking at G-matrix response
library(MASS)
library(car)
##This function plots the 99% confidence ellipse and the eigenvectors
G.ellipse <- function(G,null.bar,color,lwd=1){
##Plot the ellipse for a given G matrix (2.5 is for the 99% CI)
  ellipse(center=null.bar, shape=G, radius=2.5, center.cex=0.1, lwd=lwd, col=color, add=TRUE)

#Get eigenvectors & eigenvalues and use them to plot axes of the ellipse
  k=2.5*sqrt(eigen(G)$values[2])
  delx1 = null.bar[1] + k*eigen(G)$vectors[1,2]
  delx2 = null.bar[2] + k*eigen(G)$vectors[2,2]
  delx11 =  null.bar[1] - k*eigen(G)$vectors[1,2]
  delx22 =  null.bar[2]  - k*eigen(G)$vectors[2,2]
  x.values=c(null.bar[1], delx1, delx11)
  y.values=c(null.bar[2] , delx2, delx22)
  lines(x.values, y.values, lwd=lwd, col=color )
  
  j=2.5*sqrt(eigen(G)$values[1])
  delx1 = null.bar[1]  + j*eigen(G)$vectors[1,1]
  delx2 = null.bar[2]  + j*eigen(G)$vectors[2,1]
  delx11 = null.bar[1]  - j*eigen(G)$vectors[1,1]
  delx22 = null.bar[2]  - j*eigen(G)$vectors[2,1]
  x.values=c(null.bar[1] , delx1, delx11)
  y.values=c(null.bar[2] , delx2, delx22)
  lines(x.values, y.values, lwd=lwd, col=color )
}

##A function for making transparent color gradients
makeTransparent <- function(someColor, alpha=100){
  newColor<-col2rgb(someColor)
  apply(newColor, 2, function(curcoldata){rgb(red=curcoldata[1], green=curcoldata[2],blue=curcoldata[3],alpha=alpha, maxColorValue=255)})
}

##This function will apply a selection gradient of a particular magnitude in a circle. It divides a circle equally among the number specified by circle.stops. It applies this selection gradient for the number of generations specified.
G.circle <- function(G11,G22,r,beta.mag=1,circle.stops=10,gens=10,xlim=c(-20,20),ylim=c(-20,20)){
  ##Build the G-matrix
  G12 <- r*sqrt(G11*G22)
  G <- matrix(c(G11,G12,G12,G22),2)
  plot(xlim,ylim,type="n")
  null.bar <- c(0,0)
  ##Create a color ramp
  colors=rainbow(circle.stops)
  ##Create a vector of stopping points around the circle
  radians=seq(0,2*pi,length.out=circle.stops)
  ##Plot the original G-matrix
  G.ellipse(G,null.bar,color=1,lwd=2)
  ##Loop over the circle.stops number of selection gradients
  for(i in 1:circle.stops){
    color.i <- colors[i]
    ##Set the selection gradient
    beta <- beta.mag*c(cos(radians[i]),sin(radians[i]))
    ##Calculate the per generation response to selection R
    R <- beta%*%G
    ##Initialize zbar
    zbar <- null.bar
    ##Create a vector of transparent alpha values
    trans.ramp <- exp(seq(log(10),log(225),length.out=gens))
    ##Loop over the number of generations
    for(j in 1:gens){
      ##Make the color transparent
      color.j <- makeTransparent(color.i,trans.ramp[j])
      zbar <- zbar+as.vector(R)
      ##Plot the ellipses
      G.ellipse(G,zbar,color.j)
    }
    ##Plot the selection gradients
    arrows(0,0,gens*beta[1],gens*beta[2],col=color.i,length=0.1)
  }
}

ALplot <-  function(A11, A22, r, optimum, xlim=c(-20,20),ylim=c(-20,20),AL.color="blue",AL.lines=1000,add=FALSE, AL.maxdist=NULL){
  A12 <- r*sqrt(A11*A22)
  Omega <- matrix(c(A11,A12,A12,A22),2)
  ##Define the G-matrix
  ##Plot the adaptive landscape
  ##If add=TRUE, you will add only the G-matrix to the plot
  if(!add) plot(xlim,ylim,type="n")
  ##Color ramp for the adaptive landscape
  AL.ramp=seq(10,200,length.out=AL.lines)
  ##Determine how far you need to pot the adaptive landscape
  if(is.null(AL.maxdist)){
   AL.maxplotdist=1*max(abs(c(xlim-optimum,ylim-optimum,rev(xlim)-optimum,rev(ylim)-optimum)))
  } else {AL.maxplotdist = AL.maxdist}
  ##Set how many lines you want to plot
  AL.steps=seq(0,AL.maxplotdist,length.out=AL.lines)
  for(i in 1:AL.lines){
    ##Plot the ellipses defining the AL
    car::ellipse(optimum,Omega,center.cex=0,radius=AL.steps[i],col=makeTransparent(AL.color,alpha=AL.ramp[i]))
  }
  ##Initialize zbar
  #zbar <- start
  ##Plot the original G
  #G.ellipse(G,zbar,color=1,lwd=2)
  ##Create a transparency ramp
  #trans.ramp <- exp(seq(log(10),log(245),length.out=gens))
  ##Create an empty matrix to store results
  #Z <- matrix(start,ncol=2,nrow=gens+1)
  ##Loop over the number of generations
  #for(i in 1:gens){
  #  ##Make the color transparent
  #  col.i <- makeTransparent(G.color,alpha=trans.ramp[i])
  #  ##Calculate the selection gradient based on the current location
  #  Beta <- (optimum-zbar)%*%solve(Omega+P)
  #  ##Determine the location of the new optimum
  #  zbar <- Beta%*%G+zbar+mvrnorm(1,c(0,0),G/Ne)
  # ##Plot the G-matrix
  #  G.ellipse(G,as.vector(zbar),color=col.i,lwd=1)
  #  ##Store the results from this generation
  #  Z[i+1,] <- zbar
  #}
  ##Plot the path of the G matrix as a line...
  #lines(Z,col=makeTransparent(G.color,100),lwd=1.5)
  ##...and points for each stop
  #points(Z,bg=makeTransparent(G.color,100),col=makeTransparent(G.color,100),cex=0.5,pch=21)
  ##Return the history of the location of the G-matrix through the course of the simulation
  #return(Z)
}

##FUnction for plotting evolution on a multivariate-Gaussian Adaptive Landscape
mvBMsim <- function(sig2.11,sig2.22,r,gens, root, gen.int=1, Omega=matrix(c(10000000,0,0,1000000),2),E=matrix(c(0,0,0,0),2),xlim=c(-20,20),ylim=c(-20,20),G.color="red",AL.color="blue",AL.lines=1000,add=FALSE, npoints){
  Ne <- 1
  G11 <- sig2.11
  G22 <- sig2.22
  start <- root
  optimum <- root
  ##Define the G-matrix
  G12 <- r*sqrt(G11*G22)
  G <- matrix(c(G11,G12,G12,G22),2)
  ##Define the P-matrix
  P <- G+E
  ##Plot the adaptive landscape
  ##If add=TRUE, you will add only the G-matrix to the plot
  if(!add){
    plot(xlim,ylim,type="n")
    ##Color ramp for the adaptive landscape
    AL.ramp=seq(10,200,length.out=AL.lines)
    ##Determine how far you need to pot the adaptive landscape
    AL.maxplotdist=1*max(abs(c(xlim-optimum,ylim-optimum,rev(xlim)-optimum,rev(ylim)-optimum)))
    ##Set how many lines you want to plot
    AL.steps=seq(0,AL.maxplotdist,length.out=AL.lines)
    for(i in 1:AL.lines){
      ##Plot the ellipses defining the AL
      ellipse(optimum,Omega+P,center.cex=0,radius=AL.steps[i],col=makeTransparent(AL.color,alpha=AL.ramp[i]))
    }
  }
  ##Initialize zbar
  zbar <- start
  ##Plot the original G
  #G.ellipse(G,zbar,color=1,lwd=2)
  ##Create a transparency ramp
  trans.ramp <- exp(seq(log(10),log(245),length.out=gens))
  ##Create an empty matrix to store results
  Z <- matrix(start,ncol=2,nrow=gens, byrow=TRUE)
  ##Loop over the number of generations
  for(i in 2:gens){
    ##Make the color transparent
    col.i <- makeTransparent(G.color,alpha=trans.ramp[i])
    ##Calculate the selection gradient based on the current location
    Beta <- (optimum-zbar)%*%solve(Omega+P)
    ##Determine the location of the new optimum
    zbar <- Beta%*%G+zbar+mvrnorm(1,c(0,0),G/Ne)
    ##Plot the G-matrix
    if(i %in% seq(1, gens, gen.int)) G.ellipse(G,as.vector(zbar),color=col.i,lwd=1)
    ##Store the results from this generation
    Z[i,] <- zbar
  }
  ##Plot the path of the G matrix as a line...
  lines(Z,col=makeTransparent(G.color,175),lwd=1.5)
  ##...and points for each stop
  points(Z[floor(seq(1,gens,length.out=npoints)),],bg=makeTransparent(G.color,100),col=makeTransparent(G.color,250),cex=0.5,pch=21)
  ##Return the history of the location of the G-matrix through the course of the simulation
  return(Z)
}

#G.circle(G11=1,G22=1,r=0)
#G.circle(G11=1,G22=1,r=0.5)
#G.circle(G11=1,G22=1,r=-0.9)

#Omega=matrix(c(9,-5,-5,9),2)
#xlim=c(-20,20)
#ylim=c(-20,20)
#optimum=c(5,15)

#Z <- AdaptiveLandscape(1,1,0.4,gens=100,start=c(0,0),optimum=optimum,Omega=Omega,xlim=xlim,ylim=ylim,G.color="red",AL.lines=500)    
#Z <- AdaptiveLandscape(1,1,0.9,gens=100,start=c(0,0),optimum=optimum,Omega=Omega,xlim=xlim,ylim=ylim,G.color="purple",AL.lines=500,add=TRUE)    
#Z <- AdaptiveLandscape(1,1,-0.9,gens=100,start=c(3,0),optimum=optimum,Omega=Omega,xlim=xlim,ylim=ylim,G.color="darkgreen",AL.lines=500,add=TRUE)    


#Z <- AdaptiveLandscape(1,1,0.9,gens=100,start=c(0,0),optimum=optimum,Omega=Omega,xlim=xlim,ylim=ylim,G.color="red",AL.lines=500)    
#Z <- AdaptiveLandscape(2,1,0.9,gens=100,start=c(0,0),optimum=optimum,Omega=Omega,xlim=xlim,ylim=ylim,G.color="purple",AL.lines=500,add=TRUE)    
#Z <- AdaptiveLandscape(10,1,0.9,gens=100,start=c(0,0),optimum=optimum,Omega=Omega,xlim=xlim,ylim=ylim,G.color="darkgreen",AL.lines=500,add=TRUE)    
