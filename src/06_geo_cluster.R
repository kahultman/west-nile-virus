# Create k-means clusters based on geography and WnvPresent
suppressMessages(library(tidyverse))

load("./data/train.RData")
load("./data/test.RData")

trap_geo_hot <- train %>% group_by(Trap, Longitude, Latitude) %>% 
  summarise(number = n(), WnvTot = sum(WnvPresent)) %>% 
  mutate(WnvAvg = WnvTot/number) %>% 
  select(Trap, Latitude, Longitude, WnvAvg) %>% 
  arrange(Trap)

# Geographic + Hotspot clusters using k-means with k=6
set.seed(123)
geo.hot.cl <- kmeans(trap_geo_hot[,2:4], centers = 6)
trap_geo_hot$geo.hot.cl <- as.factor(geo.hot.cl$cluster)
#trap_geo_hot$geo.hot.cl <- as.factor(trap_geo_hot$geo.hot.cl)
#ggplot(trap_geo_hot, aes(Longitude, Latitude, color = geo.hot.cl)) + geom_point()

# Add Geographic hotspot clusters to trainset

train <- left_join(train, trap_geo_hot, by = c("Trap", "Longitude", "Latitude"))

save(train, file = "./data/train.RData")

test <- left_join(test, trap_geo_hot, by = c("Trap", "Longitude", "Latitude"))

save(test, file = "./data/test.RData")



# Distance clusters

traps

traps_geo <- as.matrix(traps[,2:3])
rownames(traps_geo) <- unlist(traps[,1])



traps.dist <- dist(traps_geo)
traps.dist
traps.hclust <- hclust(traps.dist)
plot(traps.hclust)
?dist


library(sp)
library(rgeos)

sp.traps <- traps %>% ungroup()
sp.traps <- sp.traps[unique(sp.traps$Trap)]
coordinates(sp.traps) <- ~Longitude+Latitude
