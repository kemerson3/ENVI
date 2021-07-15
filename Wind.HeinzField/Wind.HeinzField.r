## Wind data from Pittsburgh International Airport.
## Example of rose plot of wind direction

library(tidyverse) # includes ggplot and readr commands
library(RColorBrewer) # used for wind rose with color code by speed
library(lubridate) # used for dates, specifically month separation
library(dplyr)
library(readr)
install.packages("ggplot2")
library(ggplot2)
install.packages("forcats")
library(forcats)

## Heinz Field (HFP)
hfp <- read_csv("https://duq.box.com/shared/static/2cs6xi81xtcmq4mmi46t0v0ev4f2mehs.csv")
hfp$date <- as_date(hfp$Timestamp)
hfp$month <- month(hfp$date)
hfp$dir <- hfp$`Wind Vane` # degrees
hfp$spd <- 0.44704 * hfp$Anemometer # converted to m/s from mph, per https://allegheny.weatherstem.com/pitt

# OLD METHOD - no speed binning
br <- 10*(c(0:36)) # This array constructs the bins in degrees
h <- hist(hfp$dir, breaks = br)
# Make rose plot, based on:
# https://stackoverflow.com/questions/39024758/how-to-use-r-package-circular-to-make-rose-plot-of-histogram-data-on-360/39025913
# https://stackoverflow.com/questions/50163352/plot-wind-rose-in-r
angle <- h$mids
count <- h$counts
y <- data.frame(angle, count)
ggplot(y, aes(x = angle, y = count)) +
      labs(caption = "Heinz Field") +
      geom_col(fill = "gold", color = "yellow") +
      coord_polar(theta = "x", start = 0) +
      scale_x_continuous(breaks = seq(0, 360, 45)) +
      theme_linedraw() +
      theme(axis.title = element_blank(), panel.ontop = TRUE, panel.background = element_blank())

## NEW METHOD - with speed binning
# divide by direction & speed 
speed.bins <- 6 
dir.bins <- 36

######How do I decide the speed.bins & dir.bins?



wind <- array(0, dim = c(speed.bins, dir.bins))
for (i in 1:nrow(hfp)) {
  j <- ceiling(hfp$dir[i]/10)
  k <- ceiling(hfp$spd[i]/2)
  if(k >6) { #brute force correction for speeds over 12m/s
    k <- 6
  }
  wind[k,j] <- wind[k,j] + 1
}
#preallocate data via array, NA = not a number, 0 = zero
# 0 + 1 = 1, NA + 1 = NA
# dim = ...dimension, c = concatenate
# for() ...for loop (index variable in range AKA vector)



# ## Now, form long array rather than wide:
wind.long <- array(NA, dim = dir.bins*speed.bins)
speeds <- c(rep("0-2",dir.bins), rep("2-4",dir.bins), rep("4-6",dir.bins), rep("6-8",dir.bins), rep("8-10",dir.bins), rep("above 10",dir.bins)) # be sure to fill in as many as the wind bins in "wind" allocation
directions <- rep(5+10*(c(0:35)), speed.bins)
for (i in 1:speed.bins) {
  for (j in 1:dir.bins) {
    wind.long[(dir.bins*(i-1))+j] <- wind[i,j]
  }
}
#rep() .... repeat 

rose <- data.frame(directions, speeds, wind.long)
ggplot(rose, aes(fill = fct_rev(speeds), x = directions, y = wind.long)) +
  labs(caption = paste("Heinz Field")) +
  geom_bar(position="stack", stat="identity") +
  scale_fill_brewer("Speed (m/s)", palette = "Yellows") +
  coord_polar(theta = "x", start = 0) +
  scale_x_continuous(breaks = seq(0, 360, 45)) +
  theme_linedraw() +
  theme(axis.title = element_blank(), panel.ontop = TRUE, panel.background = element_blank()) # NOTE: ylim used in export

# # caption = "Pittsburgh International Airport" + 
# # caption = "Heinz Field" + 