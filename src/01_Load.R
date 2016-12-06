# Load and transform data 



weather <- read.csv('./data/weather.csv', na.strings = "M")

weather$Date <- as.Date(weather$Date, "%Y-%m-%d")


str(weather)
summary(weather$Tavg)

#impute average temp from high/low, when missing
weather$Tavg2 <- (weather$Tmax + weather$Tmin) / 2
plot(weather$Tavg, weather$Tavg2)
weather$Tavg[is.na(weather$Tavg)] <- weather$Tavg2


weather$Sunrise <- as.character(weather$Sunrise)
weather$Sunrise[weather$Sunrise == "-"] <- NA 
weather$Sunrise <- as.integer(weather$Sunrise)

weather$Sunset <- as.character(weather$Sunset)
weather$Sunset[weather$Sunset == "-"] <- NA 
weather$Sunset <- as.integer(weather$Sunset)

weather$Station <- as.factor(weather$Station)


# Precipitation
# Set trace value to 0.01, the lowest value found
weather$PrecipTotal[weather$PrecipTotal == "T"] <- 0.01
weather$PrecipTotal <- as.numeric(weather$PrecipTotal)

weather$SnowFall[weather$SnowFall == "T"] <- 0.01
weather$SnowFall <- as.numeric(weather$SnowFall)




# Engineer some features for weather
library(dplyr)
library(caTools)

# For each weather station, compute some running averages
# 3 day average temp
station1 <- filter(weather, Station == "1")
station2 <- filter(weather, Station == "2")

station1$ma3 <- runmean(station1$Tavg, 3, align = "right")
# 5 day average temp
station1$ma5 <- runmean(station1$Tavg, 5, align = "right")
# 10 day average temp
station1$ma10 <- runmean(station1$Tavg, 10, align = "right")

plot(station1$Date, station1$ma10)

# 3 day precip
station1$precip3d <- runmean(station1$PrecipTotal, 3, align = "right")
# 5 day precip
station1$precip5d <- runmean(station1$PrecipTotal, 5, align = "right")
# 10 day precip
station1$precip10d <- runmean(station1$PrecipTotal, 10, align = "right")


save(station1, file = "./data/station1.RData")

