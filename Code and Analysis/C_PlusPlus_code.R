
#####  C++

#load packages
library(Rcpp)
library(inline)
library(rbenchmark)
library(microbenchmark)

######     C++ Moving Average Function       ##############

#given R function
movingAverage  <- function(x, k) {
  n <- length(x) #length  of  input  vector
  nMA  <- n-k+1   #the  number  of  elements  in the  moving  average
  xnew  <- rep(NA, nMA) #to store  moving  average
  
  i <- 1 #counter  variable
  #to  calculate  moving  average , will  calculate  average  of
  #the  next k elements  starting  from  position i
  while( i  <= nMA ){ #until  the  last  moving  average
    #calculate  average  for k values  starting  from  element i
    xnew[i] <- mean( x[ ( i:(i+k-1) ) ])
    i <- i+1
  }
  xnew #return  moving  average  of  period k
}  
################

#write body of C++ function as character in R


move2<-'
NumericVector dat(x);//define vector passed from R as C++ data type
int window = as<int>(k); //define integer passed from R as C++ data type     
int n = dat.size(); //get length of vector passed from R
NumericVector ret(n-window+1); //define a vector to store the moving averages to pass back to R
double summed = 0.0; //define a float variable for in-loop calcuations
int numMA = (n -window + 1); //  number of elements in moving average and length of ret vector
int i =0;

while( i  <= numMA ){ //loop to continue until last window of moving  average
  summed = 0.0; // Reinitialize summed back to zero.
  
  for (int j = i; j < i + window; j++) { //new loop to calculate each moving average window
    summed += dat[j]; // increment sum
  } // end of for loop
  
  ret[i] = summed / window;  // move to output vector 
  ++i;  //advance to next iteration
}// end of while
return wrap(ret); // return ret vector to R
'

#cxxfunction to compile, link, load
rcppMovingAverage <- cxxfunction(signature ( x = "numeric", k = "integer"),
                                 body = move2,
                                 plugin = "Rcpp",
                                 verbose=TRUE)

x <- c(3,3,9,1,9,8,0,7)

movingAverage(x, 5)
rcppMovingAverage(x,5)

set.seed(100) #Generate a vector of random Normal data in R as follows:
x <- rnorm(1000)
k <- 2

#call function to test results are equivalent to R function
MAR<-movingAverage(x, 5)
MACPP<-rcppMovingAverage(x,5)

#compare time of both functions
benchmark <- microbenchmark(rcppMovingAverage(x,k), movingAverage(x, k),times = 10)

#Use your code to plot 5-year average (from 1882-2017) and 30-year average (from 1894-2004
k5 <-5
x <- LandOceanTempInd
year5 <- rcppMovingAverage(x,5)  
year30 <- movingAverage(x,30)  

plot.new()
#calculate 5-year and 30 year moving average using rcpp code and plot from 1882:2017
rcpp_LandOceanTempInd5 <- rcppMovingAverage(LandOceanTempInd, k=5)
rcpp_LandOceanTempInd30 <- rcppMovingAverage(LandOceanTempInd, k=30)
plot(year,LandOceanTempInd)
lines(year[3:138],rcpp_LandOceanTempInd5,col="blue")
lines(year[15:125],rcpp_LandOceanTempInd30, col="green")
title(main="Comparison of 5 and 30 year Moving Average", cex=0.8)
legend("topleft",
       legend = c("5-year moving average","30-year moving average"), 
       col = c("blue","green"),
       pch = c(19,19), 
       bty = "n", 
       pt.cex = 1, 
       cex = 1, 
       text.col = "black", 
       horiz = F , 
       inset = c(0.1, 0.1)
)

#######     C++ Random Walk Function       ##############

set.seed(18210408) #generate random numbers

#write body of C++ function as character in R
steps <-'
int steps = as<int>(stepsR); //define integer passed from R as C++ data type     
int i = 0; //define iteration counter
int reach_dest = 0; //counter for number of times tourist office is reached
int x = 0; //initialise x coordinates
int y=0; //initialise y coordinates

for (i=0;i<steps;i++){ //loop iterates over sequence 1:steps
  int step_x = int(rand() % 3)-1; //random generate 0, 1 or -1 to update x and y
  int step_y = int(rand() % 3)-1;
  x += step_x; // add updated position to x and y
  y+= step_y;
  
  if (x==-1 and y == 3){ //check if the tourist office is reached
  reach_dest += 1;    //count the number of times it is reached 
  continue; //exit this loop and return to the beginning to start next iteration
  }
  
}  
//pass back to R, the number of visits to each tourist office
  
  return wrap(reach_dest);//pass vector ret back to R

'

#cxxfunction to compile, link, load
rcppRandomWalk <- cxxfunction(signature ( stepsR = "int"),
                              body = steps,
                              plugin = "Rcpp",
                              verbose=TRUE)
rcppRandomWalk(10000) #check if code returns expected output


roads <- 20
tourists <- 1000 #the number of tourists that completed a walk over 20 roads
reached_office <- sum(replicate(tourists,rcppRandomWalk(roads)))  #number of tourists that reached the tourist office
Prob <- reached_office/tourists



# potential new offices (3,0) or (0,3) 
#write body of C++ function as character in R
steps2 <-'
int steps = as<int>(stepsR); //define integer passed from R as C++ data type     
int i = 1; //define iteration counter
int reach_dest = 0; //counter for number of times tourist office is reached
int reach_dest1 = 0; //counter for number of times tourist office 1 is reached
int reach_dest2 = 0; //counter for number of times tourist office 2 is reached
int x = 0; //initialise x coordinates
int y=0; //initialise y coordinates
IntegerVector vect = IntegerVector::create(); //vector to store return values to R

for (i=0;i<steps;i++){ //loop iterates over sequence 1:steps
  int step_x = int(rand() % 3)-1; //random generate 0, 1 or -1 to update x and y
  int step_y = int(rand() % 3)-1;
  x += step_x; // add updated position to x and y
  y+= step_y;
  
  if (x==-1 and y == 3){ //check if the tourist office is reached
  reach_dest += 1;  //count the number of times it is reached in this walk
  continue; //exit this loop and skip to next iteration
  }
  if (x==3 and y == 0){ //check if the tourist office 1 is reached
  reach_dest1 += 1;  //count the number of times it is reached in this walk
  continue; //exit this loop and skip to next iteration
  }
  if (x==0 and y == -3){ //check if the tourist office 2 is reached
  reach_dest2 += 1;  //count the number of times it is reached in this walk
  continue; //exit this loop and skip to next iteration
  }
}  
return Rcpp::List::create (
  Rcpp::Named ("exist_office", reach_dest),
  Rcpp::Named ("office1", reach_dest1), 
  Rcpp::Named ("office2",reach_dest2));
//pass back to R, the number of visits to each tourist office

 
//pass back to R, list of the number of visits to all tourist offices
'

#cxxfunction to compile, link, load
rcppRandomWalk2 <- cxxfunction(signature ( stepsR = "int"),
                               body = steps2,
                               plugin = "Rcpp",
                               verbose=TRUE)

rcppRandomWalk2(100) #check if code returns expected output

#check the probability of finding existing office or office 1 in 10 roads
roads <- 10
tourists <- 1000 #the number of simulated tourists that completed a walk over 10 roads
reached_offices <- replicate(tourists,rcppRandomWalk2(roads))  #number of tourists that reached any of the tourist offices or missed any of them

table2 <- data.frame(matrix(unlist(reached_offices), nrow=1000, ncol=3,byrow=T))
colnames(table2) <-c("Existing Office", "Proposed Office 1","Proposed Office 2")

#sometimes the same office reached more than once, but this might be a different issue to the question of reaching it at all
#find x>=1 the prob of reaching an office one or more times (signified by "hit") during a walk
table2$exist_hit <- table2[,1]>=1
table2$office1_hit <-table2[,2]>=1
table2$office2_hit <-table2[,3]>=1 

#check how many times existing or the proposed new office are reached in one walk
table2$exist_or2 <-table2[,1]>=1 | table2[,2]>=1
table2$exist_or3 <-table2[,1]>=1 | table2[,3]>=1

#find probabilities
prob_all <- colSums(table2)/1000



