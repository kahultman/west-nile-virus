# Create animated map
library(tidyverse)
library(gganimate)
library(animation)

load("./data/train.RData")

byyearweek <- group_by(train, Year, Week) %>% summarize(weekly_avg_mosq = mean(NumMosquitos))

train$timepoint <- ((train$Year - 2007) + (train$Week / 52)) * 52

map_mosq <- ggplot(train, aes(x=Longitude, y=Latitude, 
                                  size=NumMosquitos, 
                                  color=WnvPresent,
                                  frame=timepoint)) + geom_point(alpha = .5) + 
                                  ggtitle("Animated map of mosquitos and \npresence of West Nile Virus in Chicago \n")


map_mosq

gganimate(map_mosq, interval=0.5, filename = "./images/mosq_map.gif")

