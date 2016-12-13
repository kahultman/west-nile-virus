# Load and transform data 
# Very basic data manipulation for getting data into .Rdata format.

library(tidyverse)
#library(plyr)
# weather.csv ---> weather.Rdata
weather <- read_csv('./data/weather.csv', na = c("M", "-", ""))

weather$Station <- as.factor(weather$Station)
weather$CodeSum <- as.factor(weather$CodeSum)

# Change missing "-" sunset/sunrise to NA
weather$Sunrise <- as.integer(weather$Sunrise)
weather$Sunset <- as.integer(weather$Sunset)


# Precipitation
# Set trace value to 0.01, the lowest value found
weather$PrecipTotal[weather$PrecipTotal == "T"] <- 0.01
weather$PrecipTotal <- as.numeric(weather$PrecipTotal)

# Set trace to 0.01 for snowfall
weather$SnowFall[weather$SnowFall == "T"] <- 0.01
weather$SnowFall <- as.numeric(as.character(weather$SnowFall))

# Deal with missing data  - NA's

# impute average temp from high/low, when missing
weather$Tavg2 <- (weather$Tmax + weather$Tmin) / 2
weather$Tavg[is.na(weather$Tavg)] <- weather$Tavg2[is.na(weather$Tavg)]

# Delete uninformitive columns
# Departure from normal was not informative with linear regression and has many NA's - remove
weather$Depart <- NULL
# These have no data
weather$Depth <- NULL
weather$Water1 <- NULL

# Sunrise and Sunset can use previous day's value
prevday <- weather %>% mutate(pSunset = lag(Sunset), pSunrise = lag(Sunrise)) %>% select(Date, pSunset, pSunrise)
weather$Sunset[is.na(weather$Sunset)] <- prevday$pSunset[is.na(weather$Sunset)]
#sum(is.na(weather$Sunset))

weather$Sunrise[is.na(weather$Sunrise)] <- prevday$pSunrise[is.na(weather$Sunrise)]
#sum(is.na(weather$Sunrise))

# Variables to be set to 0 or the mean observed value
weather <- weather %>% replace_na(list(PrecipTotal = 0, 
                                       SnowFall = 0, 
                                       StnPressure = mean(weather$StnPressure, na.rm = TRUE),
                                       SeaLevel = mean(weather$SeaLevel, na.rm = TRUE),
                                       AvgSpeed = mean(weather$AvgSpeed, na.rm = TRUE),
                                       WetBulb = mean(weather$Wetbulb, na.rm = TRUE),
                                       Heat = mean(weather$Heat, na.rm = TRUE),
                                       Cool = mean(weather$Cool, na.rm = TRUE)))

weather$WetBulb[is.na(weather$WetBulb)] <- mean(weather$WetBulb, na.rm = TRUE)



# 
#
# Engineer some features for weather
#



library(caTools)

# For each weather station, compute some running averages
# 3 day average temp
station1 <- filter(weather, Station == "1")
#station2 <- filter(weather, Station == "2")

station1$ma3 <- runmean(station1$Tavg, 3, align = "right")
# 5 day average temp
station1$ma5 <- runmean(station1$Tavg, 5, align = "right")
# 10 day average temp
station1$ma10 <- runmean(station1$Tavg, 10, align = "right")


# 3 day precip
station1$precip3d <- runmean(station1$PrecipTotal, 3, align = "right")
# 5 day precip
station1$precip5d <- runmean(station1$PrecipTotal, 5, align = "right")
# 10 day precip
station1$precip10d <- runmean(station1$PrecipTotal, 10, align = "right")


save(station1, file = "./data/station1.RData")
save(weather, file = "data/weather.Rdata")
