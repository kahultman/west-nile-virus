# Load and transform data 
# Very basic data manipulation for getting data into .Rdata format.

library(tidyverse)
#library(plyr)
# weather.csv ---> weather.Rdata
weather <- read.csv('./data/weather.csv', na.strings = "M")
weather$Date <- as.Date(weather$Date, "%Y-%m-%d")
weather$Station <- as.factor(weather$Station)

# impute average temp from high/low, when missing
weather$Tavg2 <- (weather$Tmax + weather$Tmin) / 2
weather$Tavg[is.na(weather$Tavg)] <- weather$Tavg2[is.na(weather$Tavg)]

# Change missing "-" sunset/sunrise to NA
weather$Sunrise <- as.character(weather$Sunrise)
weather$Sunrise[weather$Sunrise == "-"] <- NA 
weather$Sunrise <- as.integer(weather$Sunrise)

weather$Sunset <- as.character(weather$Sunset)
weather$Sunset[weather$Sunset == "-"] <- NA 
weather$Sunset <- as.integer(weather$Sunset)

# Precipitation
# Set trace value to 0.01, the lowest value found
weather$PrecipTotal <- as.character(weather$PrecipTotal)
weather$PrecipTotal[weather$PrecipTotal == "T"] <- 0.01
weather$PrecipTotal <- as.numeric(weather$PrecipTotal)

# Set trace to 0.01 for snowfall
levels(weather$SnowFall)[levels(weather$SnowFall)=="  T"] <- "0.01"
weather$SnowFall <- as.numeric(as.character(weather$SnowFall))



# 02_weather
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