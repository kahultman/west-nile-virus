# Test Set 
#
# 
#

suppressMessages(library(tidyverse))

test <- read_csv("./data/test.csv")

test$Date2 <- as.POSIXlt(test$Date)
test$Year <- test$Date2$year+1900
test$Week <- floor((test$Date2$yday - test$Date2$wday + 7) /7)

test$Summer <- abs(32-test$Week)

test$Date2 <- NULL


test$Species <- fix_species(test$Species)


test <- select(test, 
                -Address,
                -Block,
                -Street,
                -AddressNumberAndStreet,
                -AddressAccuracy)


save(test, file = "./data/test.RData")

