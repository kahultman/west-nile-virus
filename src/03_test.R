# Test Set 
#
# 
#


library(tidyverse)

test <- read.csv("./data/test.csv")
str(test)
test$Date <- as.Date(test$Date, "%Y-%m-%d")

test$Date2 <- as.POSIXlt(test$Date)
test$Year <- test$Date2$year+1900
test$Week <- floor((test$Date2$yday - test$Date2$wday + 7) /7)

test$Summer <- abs(32-test$Week)

test$Date2 <- NULL

save(test, file = "./data/test.RData")
