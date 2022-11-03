# Using C++ to Implement Efficient Algorithms in R

<img align="right" src="https://user-images.githubusercontent.com/29300100/199288013-98372234-47df-4f99-876d-a268f46f351e.png" width="200">

## Background
The efficiency and speed of a function can often be optimised by defining it in C++ and calling it from R, as opposed to using available R packages or functions. 

## Objective
The aim of this project is to generate efficient functions for calculating moving average of period k across a vector using a C++ function that is callable from R and to benchmark this function against the orginal R-function, and apply it to investigate the changes in climate temperature over the last century.  A second objective is to define a random walk function, and to apply it to characteise the movement of a tourist across a town.

## Data and Analysis
A function was written in C++ to calculate the moving average and implemented in R using the cxxfunction of the RCPP package.  Function arguments passed from R to C++ were a vector (x) that contained the data to be averaged, and an integer (k) that gave the size of the moving average window.  The function consisted of a for loop that iterated through the elements of vector x, summing the elements within each sequential window, dividing by the window length, storing the result in a vector that was finally returned to R at the end of the loop.  A while loop controlled the progress of the function, ending when the last window length in the vector passed from R is reached.  The function speed was returned using the command microbenchmark, from the microbenchmark package in R.

A second function was written in C++ to calculate a random walk.  The code was implemented in R using the cxxfunction of the RCPP package.  Function arguments passed from R to C++ were an integer that contained the number of walks that were to be simulated using the model.  The function consisted of a single for loop that iterated through the length of the walk integer passed from R.  A random number generator returned 0, 1 or -1 that was stored in a “step” variable to indicate the step taken at each iteration.  The value for step was next used to update a vector that indicated the current position along the x and y coordinates.  An if statement was used to check if the current position matched the destination and if this was true, then an integer variable “reach_dest” that stored the number of times the destination was reached was advanced by one.  This variable was returned to R at the end of the loop.

Further details of the functions are [here](https://github.com/cawyse9/Implementing-Efficent-Gradient-Descent-Algorithm-in-R-/blob/main/Code%20and%20Analysis/C_PlusPlus%20Project.pdf)  

The R code used to implement the C++ functions is [here](https://github.com/cawyse9/Implementing-Efficent-Gradient-Descent-Algorithm-in-R-/blob/main/Code%20and%20Analysis/C_PlusPlus_code.R)

## Conclusion
The Rcpp functions were superior to the R functions in terms of speed of processing. The Rcpp function coded for a moving average function was used to calculate moving average ocean temperatures in five year windows (from 1882–2017) and 30-year windows (from 1894–2004). The 30 year window smooths out variation over shorter time periods, and a 5 year window made the upward trajectory of temperature since 1920 more clear.  The 30-year window removes the effects of year-to-year changes in temperature that are of small consequence to the overall trend across the 140 year time range

## Acknowledgments
This project was submitted as part of the coursework required for the module, "Programming in C++" for an a MSc (Data Analytics) course at UCD in 2022. 
