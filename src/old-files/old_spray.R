# Load Spray data
library(tidyverse)

spray <- tbl_df(read.csv("./data/spray.csv"))

spray$Date <- as.Date(spray$Date, "%Y-%m-%d")

spray$Date2 <- as.POSIXlt(spray$Date)
spray$Year <- spray$Date2$year+1900
spray$Week <- floor((spray$Date2$yday - spray$Date2$wday + 7) /7)
spray$Date2 <- NULL


save(spray, file = "./data/spray.RData")





# ## Combine spray data with training data
# #
# # Variables to add
# # Distance to last spray
# # Time since last spray
# # minSprayTD2 = min(time since last spray * distance to spray ^ 2)
# 
# load("./data/trainset1.RData")
# trainset1 <- tbl_df(trainset1)
# 
# 
# trainset1  
# spray
# 
# distance_to_spray <- function(){
#   ?dist()
# }
# 
# 
# 
# spray <- filter(spray, Latitude < 42.1)
# spray$Year <- as.integer(spray$Year)
# 
# ggplot(spray, aes(x=Longitude, y=Latitude, color=Date)) + geom_point()
# 
# + facet_wrap(~Year)
# 
# spray %>% group_by(Date) %>% summarise(Num = n()) %>% ggplot(.,aes(x=Date, y=Num)) + geom_point()
# ggplot(spray, aes(x=Date)) + geom
# 
# spraysample <- filter(spray, Date<"2011-09-08")
# ggplot(spraysample, aes(x=Longitude, y=Latitude, color=Date)) + geom_point()
# 
# 
# 
# ggplot(trainset1, aes(x=Date, y=NumMosquitos)) + geom_point()
# 
# # Take samples from 2013 to see Spray effect
# unique(spray$Date)
# spraysample <- filter(spray, Date=="2013-07-17")
# 
# ggplot(spraysample, aes(x=Longitude, y=Latitude)) + geom_point(aes(color=Date, alpha=0.5))
# 
# trainset1sample <- filter(trainset1, Year==2013 & Date < "2013-08-07" )
# 
# library(pdist)
# 
# spraylocations <- select(spraysample, Latitude, Longitude)
# spraylocations <- as.matrix(spraylocations)
# 
# trainset1locations <- select(trainset1sample, Latitude, Longitude)
# trainset1locations <- as.matrix(trainset1locations)
# 
# spraytrain.dist <- pdist(spraylocations, trainset1locations)
# 
# str(spraytrain.dist)
# spraytrain.dist <- as.matrix(spraytrain.dist)
# spraytrain.dist <- spraytrain.dist * spraytrain.dist
