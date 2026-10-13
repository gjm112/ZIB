 rbetamu <- function(n,mu,phi){
  a = mu*phi 
  b  = (1-mu)*phi
  rbeta(n,a,b)
}

dbetamu <- function(x,mu,phi, log = TRUE){
  a = mu*phi 
  b  = (1-mu)*phi
  return(dbeta(x,a,b, log = log))
}

#x is the predictor matrix for non zero values
#z is the predictor matrix for zero values 
p <- 5
n <- 100000
z <- matrix(rnorm(n*p,0,1), ncol = p)
x <- matrix(rnorm(n*p,0,1), ncol = p)
phi <- 100
gamma <- c(1,1,0,0,0)
beta <- c(0,1,0,1,0)

#Probability of a 0
pi <- plogis(z %*% gamma)

#Mean of non zero 
mu <- plogis(0 + x %*% beta)


b <- rbinom(n,1,1-pi)

w <- rbetamu(n,mu,phi)

y <- b*w


#Likelihood of 0 part
ll <- function(theta, y, x, z){

p <- ncol(x)
gamma <- theta[1:p]  
beta <- theta[(p+1):(2*p)]
phi <- theta[2*p + 1]
gamma0 <- theta[2*p + 2]
beta0 <- theta[2*p + 3]
  
llgamma <- sum((y == 0)*log(plogis(gamma0 + z %*% gamma)) + 
      (y != 0)*log(1-plogis(gamma0 + z %*% gamma)))

#Likelihood of non zero part. 


llbeta <- sum(dbetamu(y[y!=0], plogis(beta0+ x %*% beta)[y!=0], phi, log = TRUE))

return(llbeta + llgamma)
}
ll(c(1,1,1,1,1,1,1,1,1,1,1,1,1), y = y, x = x, z = z)
ll(c(2,2,0,0,0,0,1,0,1,0,10,1,1), y = y, x = x, z = z)
ll(c(0,0,0,0,0,0,0,0,0,0,10,1,1), y = y, x = x, z = z)

optim(c(0,0,0,0,0,0,0,0,0,0,100,1,1),ll, y = y, x = x, z = z,  control = list(fnscale = -1, maxit = 5000))

#Now penalize it 

ll_pen <- function(theta, y,x,z,lambda_gamma = 100, lambda_beta = 100){
  
  p <- ncol(x)
  n <- nrow(x)
  gamma <- theta[1:p]  
  beta <- theta[(p+1):(2*p)]
  phi <- theta[2*p + 1]
  
  return(ll(theta,y=y,x=x,z=z)/n - lambda_gamma*sum(gamma) - lambda_beta*sum(beta))
  
}


ll_pen(c(0,0,0,0,0,0,0,0,0,0,100,1,1), y=y, x = x, z = z)

#max ll_pen
optim(c(0,0,0,0,0,0,0,0,0,0,100,1,1),ll_pen, y = y, x = x, z = z,  control = list(fnscale = -1, maxit = 10000))

#sample size
n <- 100
z <- rbinom(n,1,1-pi)

beta <- 2
x <- runif(n,0,1)
mu <- plogis(0 + beta*x)
phi <- 10
b <- rbetamu(n,mu,phi)



y <- b*z


#Likelihood




plot(x,y)

# mu <- a/ (a + b)
# phi <- (a + b)

#pdf of beta in alternate parametrization
dbetamu <- function(y,mu,phi){
  a = mu*phi 
  b  = (1-mu)*phi
  dbeta(y,a,b, log = TRUE)
}

#a = mu*phi
#b  = (1-mu)*phi


#Do maximum likelihood

ll <- function(theta){
  mu <- plogis(0 + theta[1]*x)
  out <- -sum(dbetamu(y,mu,theta[2]))
  return(out)
}

optim(c(0,1), ll)


llp <- function(theta, lambda){
  mu <- plogis(0 + theta[1]*x)
  out <- -sum(dbetamu(y,mu,theta[2])) + lambda*log(abs(theta[1]))
  return(out)
}

results <- data.frame() 
for (i in seq(0,100,10)){
  theta <- optim(c(1,1), llp, lambda = i)$par
  temp <- data.frame(beta = theta[1],phi = theta[2], lambda = i)
  results <- rbind(results, temp)
}

library(tidyverse)
results %>% ggplot(aes(x = lambda, y = beta )) + geom_point()

