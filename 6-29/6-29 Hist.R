library(e1071)
library(readr)
setwd("C:/Users/kjeme/Downloads")
data <- read.csv("2622217.csv")
data$TOBS
m <- mean(data$TOBS, na.rm = TRUE)
s <- sd(data$TOBS, na.rm = TRUE)
sk <-skewness(data$TOBS, na.rm = TRUE)
k <-kurtosis(data$TOBS, na.rm = TRUE)
  h <-hist(data$TOBS, breaks = c(-30, -20, -10, 0, 10, 20, 30)

           