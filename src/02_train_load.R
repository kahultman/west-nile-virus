# Train

train <- read.csv("./data/train.csv")
str(train)
train$Date <- as.Date(train$Date, "%Y-%m-%d")
train$WnvPresent <- as.logical(train$WnvPresent)
?as.Date
train$Date2 <- as.POSIXlt(train$Date)
train$Year <- train$Date2$year+1900
train$Week <- floor((train$Date2$yday - train$Date2$wday + 7) /7)

train$Summer <- abs(32-train$Week)

train$Date2 <- NULL

library(dplyr)
trainshort <- select(train, 
                     Date, 
                     Year,
                     Week,
                     Summer,
                     Species,
                     Trap,
                     NumMosquitos,
                     WnvPresent) 



save(train, file = "./data/train.RData")
save(trainshort, file = "./data/trainshort.RData")
