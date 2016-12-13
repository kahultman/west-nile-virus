# Test Set 
#
# 
#
suppressMessages(library(plyr))
suppressMessages(library(tidyverse))

test <- read_csv("./data/test.csv")

test$Date2 <- as.POSIXlt(test$Date)
test$Year <- test$Date2$year+1900
test$Week <- floor((test$Date2$yday - test$Date2$wday + 7) /7)

test$Summer <- abs(32-test$Week)

test$Date2 <- NULL

test <- test %>% mutate(c.pip = ifelse(Species == "CULEX PIPIENS", 1, 0), 
                          c.res = ifelse(Species == "CULEX RESTUANS", 1, 0),
                          c.pip.c.res = ifelse(Species == "CULEX PIPIENS/RESTUANS", 1, 0), 
                          c.ter = ifelse(Species == "CULEX TERRITANS", 1, 0),
                          c.oth = ifelse(!(Species %in% c("CULEX PIPIENS", "CULEX RESTUANS", "CULEX PIPIENS/RESTUANS", "CULEX TERRITANS")), 1,0))

test <- test %>% mutate(Species2 = Species) 

test$Species2 <- revalue(test$Species2, c("CULEX ERRATICUS" = "OTHER",
                                            "CULEX SALINARIUS" = "OTHER",
                                            "CULEX TERRITANS" = "OTHER"))

test <- select(test, 
                -Address,
                -Block,
                -Street,
                -AddressNumberAndStreet,
                -AddressAccuracy)


save(test, file = "./data/test.RData")
