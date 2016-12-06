# Load and transform data 
# Very basic data manipulation for getting data into .Rdata format.

#library(tidyverse)
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

save(weather, file = "data/weather.Rdata")

