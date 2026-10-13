rbetamu <- function(x,mu,phi){
  a = mu*phi 
  b  = (1-mu)*phi
  rbeta(x,a,b)
}


beta <- 2
x <- runif(1000,0,1)
mu <- plogis(0 + beta*x)
phi <- 10
y <- rbetamu(1000,mu,phi)

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

