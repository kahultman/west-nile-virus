# Combine weather data with training and test set

load("./data/station1.RData")
load("./data/trainshort.RData")
load("./data/train.RData")
suppressMessages(library(tidyverse))

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

train <- left_join(train, station1select, by = "Date")
save(train, file = "./data/train.RData")


load("./data/test.RData")
test <- left_join(test, station1select, by = "Date")
save(test, file = "./data/test.RData")


