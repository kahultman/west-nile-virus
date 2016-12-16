# Create k-means clusters based on geography and WnvPresent
suppressMessages(library(tidyverse))

load("./data/train.RData")
load("./data/test.RData")

WnvPresentOverall <- table(train$WnvPresent)[2] / sum(table(train$WnvPresent))

trap_geo_hot <- train %>% group_by(Trap, Longitude, Latitude) %>% 
  summarise(number = n(), WnvTot = sum(WnvPresent)) %>% 
  mutate(WnvAvg = WnvTot/number) %>% 
  select(Trap, Latitude, Longitude, WnvAvg) %>% 
  arrange(Trap)

test_geo <- test %>% group_by(Trap, Longitude, Latitude) %>% 
  summarise(number = n()) %>%
  select(Trap, Latitude, Longitude) %>% 
  arrange(Trap)

trap_geo_hot <- full_join(trap_geo_hot, test_geo)
trap_geo_hot$WnvAvg[trap_geo_hot$WnvAvg == 0] <- WnvPresentOverall
trap_geo_hot$WnvAvg[is.na(trap_geo_hot$WnvAvg)] <- WnvPresentOverall

# Geographic + Hotspot clusters using k-means with k=6
set.seed(123)
geo.hot.cl <- kmeans(trap_geo_hot[,2:4], centers = 6)
trap_geo_hot$geo.hot.cl <- as.factor(geo.hot.cl$cluster)

#trap_geo_hot$geo.hot.cl <- as.factor(trap_geo_hot$geo.hot.cl)
#ggplot(trap_geo_hot, aes(Longitude, Latitude, color = geo.hot.cl)) + geom_point()

# Add Geographic hotspot clusters to trainset

train_geo <- left_join(train, trap_geo_hot, by = c("Trap", "Longitude", "Latitude"))

test_geo <- left_join(test, trap_geo_hot, by = c("Trap", "Longitude", "Latitude"))



save(train_geo, file = "./data/train_geo.RData")
save(test_geo, file = "./data/test_geo.RData")
save(trap_geo_hot, file = "./data/trap_geo_hot.RData")
