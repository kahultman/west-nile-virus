# Combine weather data with training set

load("./data/station1.RData")
load("./data/trainshort.RData")
load("./data/train.RData")
library(dplyr)

station1select <- select(station1, 
                         Date,
                         Tmax,
                         Tmin,
                         Tavg,
                         Depart,
                         DewPoint,
                         WetBulb,
                         Sunrise,
                         Sunset,
                         PrecipTotal,
                         ResultSpeed,
                         ma3,
                         ma5,
                         ma10,
                         precip3d,
                         precip5d,
                         precip10d)

trainset1 <- left_join(trainshort, station1select, by = "Date")
save(trainset1, file = "./data/trainset1.RData")


trainset2 <- left_join(train, station1select, by = "Date")
save(trainset2, file = "./data/trainset2.RData")
library(caret)
?findCorrelation()
