#basic stats on Beitbridge data
library(readr)
library(dplyr)
library(tidyr)
library(lubridate)
file <- file.choose()
#stores in the variable file
beit <-read_csv(file, skip = 7, n_max = 28)
#skips first 7 lines of the data in excel file that are formatting but not necessary
head(beit)
tail(beit)
beit <- beit[1:28,]
#cuts off the junk at the tail and renames the beit in the environment

mean(beit$`Flow (cumec)`)
sd(beit$`Flow (cumec)`) #this is the sample standard deviation

m <- max(beit$`Flow (cumec)`)
i <-which(beit$`Flow (cumec)` == m)
beit[which.max(beit$`Flow (cumec)`), ]
# the comma in above is necessary, it needs a second 'direction'

beit[which.min(beit$`Flow (cumec)`), ]

#double equals sign is a test of equality
#logical operators: ==, <, <=, >, >=, != is not equal
#the 21 that is returned corresponds to the value where the max value is found in the excel sheet
#square brackets are indices and location values
#types of brackets:
# () for input functions
# [] locations
# {} loop commands
# for (i in 1:10) {
#   loop commands
# }

# variables: 
single.variables <- 13
vectors_or_lists <- c(5+6, single.variables, 1:3)
# c stands for stack the values he called it catcatanate
first <- c(1:3)
second <- c(4:8)
third <- cbind(first,second)
fourth <- rbind(first,second)
df <- data.frame("col1" = c("A", "b", "c", "d", "e"), 
                 "col2" = vectors_or_lists, 
                 "col3" = c(1:5))

#manipulate some data!
beit.f <- select(beit, Year, 'Flow (cumec)')
y2k <- filter(beit, Year == 2000)
#pulls out information from the year 2000
beit.f <- mutate(beit.f, flow_lps = 1000*`Flow (cumec)`) #dplyor method to add column
#make sure you use tick marks next to the 1 instead of the single quotations

#wide versus long
beit.l <- beit%>%
  mutate(flow_lps = 1000*`Flow (cumec)`) %>%
  select(Year, `Level (m)`, flow_lps) %>%
  pivot_longer(cols = c(`Level (m)`, flow_lps),
               names_to = "Variable",
               values_to = "Value")
#above is pipe command with the % signs

beit.w <- beit.l %>%
  pivot_wider(names_from = Variable,
              values_from = "Value")

#Dates and huge data sets
file <- file.choose()
mutale <- read_csv(file)
head(mutale)
str(mutale)
#click on packages to see what packages have been installed

mutale1 <- mutale %>%
  mutate(datetime = ymd_hm(paste(YEAR, MONT, DAYN, HOUR, MINU))) %>%
  na_if(-9999) %>%
  na_if(-8888) %>%
  na_if(-7777) %>%
  select(-YEAR, -MONT, DAYN, -HOUR, -MINU) %>%
  rename(precip_mm =PRCP,
         airtemp_c = TEMP,
         humid_p = RHMD,
         solRad_wm2 = SRAD,
         AirPres_kPa = APRS,
         Wind_sp = WSPD,
         WindDir = WDIR,
         RivStage_m = RIVS,
         watertemp = WTMP,
         Cond_US_cm = COND,
         Tubidity = TRBD)

#creating a new column above for date time with year month etc while removing values 
#we dont need and removing the other date columns since datetime accounts for all
#lubidity uses the starting time of midnight 1/1/1970

file <- file.choose()
disasters <- read_csv(file, skip = 6, col_names = TRUE, col_types = "ciifffffcfffffccfffccnnfcccciiiiiiiiiiinnnn")

events <- disasters %>%
  filter(Year <= 2013) %>%
  group_by(Continent) %>%
  summarize(Events = length(Continent))

deaths <- disasters %>%
  group_by(Continent) %>%
  summarize(Deaths = sum(`Total Deaths`, na.rm = TRUE))
  