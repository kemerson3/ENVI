library(readr)
library(ggplot2)
wind <- read.csv("pgh_weather.csv")
dir <- hist(wind$Wind.Dir)
br <-10*(c(0:36))
#star necessary after 10
dir <- hist(wind$'Wind.Dir', breaks = br)
angle <-dir$mids
count <-dir$counts
y <- data.frame(angle, count)
ggplot(y, aes(x = angle, y = count)) + 
  geom_col(fill = 'steelblue', color = "steelblue") +
  coord_polar(theta = "x", start = 0) #theta = angle
