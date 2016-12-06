# 02_weather
#
# Engineer some features for weather
#


library(dplyr)
library(caTools)

load("./data/weather.Rdata")

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
