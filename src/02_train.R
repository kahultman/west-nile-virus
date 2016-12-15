# Train

suppressMessages(library(tidyverse))
train <- read_csv("./data/train.csv")


#train$Date <- as.Date(train$Date, "%Y-%m-%d")
train$WnvPresent <- as.logical(train$WnvPresent)

train$Date2 <- as.POSIXlt(train$Date)
train$Year <- train$Date2$year+1900
train$Week <- floor((train$Date2$yday - train$Date2$wday + 7) /7)
train$Week <- as.integer(floor((train$Date2$yday - train$Date2$wday + 7) /7))
train$Summer <- abs(32-train$Week)
train$Date2 <- NULL

# train <- train %>% mutate(c.pip = ifelse(Species == "CULEX PIPIENS", 1, 0), 
#                           c.res = ifelse(Species == "CULEX RESTUANS", 1, 0),
#                           c.pip.c.res = ifelse(Species == "CULEX PIPIENS/RESTUANS", 1, 0), 
#                           c.ter = ifelse(Species == "CULEX TERRITANS", 1, 0),
#                           c.oth = ifelse(!(Species %in% c("CULEX PIPIENS", "CULEX RESTUANS", "CULEX PIPIENS/RESTUANS", "CULEX TERRITANS")), 1,0))


add_week_avg_mosq <- function(df){
  weeklyAvgNumMosq <- df %>% group_by(Week) %>% summarise(WeekAvgMos = mean(NumMosquitos)) %>% ungroup()
  df <- left_join(df, weeklyAvgNumMosq, by = "Week")
  df
}


fix_species <- function(x){
  x <- gsub("ERRATICUS", "OTHER", x) %>% 
    gsub("SALINARIUS", "OTHER", .) %>% 
    gsub("TARSALIS", "OTHER", .) %>% 
    gsub("UNSPECIFIED CULEX", "CULEX OTHER",.)
}

train$Species <- fix_species(train$Species)


train <- select(train, 
                     -Address,
                     -Block,
                     -Street,
                     -AddressNumberAndStreet,
                     -AddressAccuracy)
                     

save(train, file = "./data/train.RData")

## Extract trap locations

traps <- train %>% group_by(Trap, Longitude, Latitude) %>% summarise(number =n()) %>% arrange(Trap)
save(traps, file = "./data/traps.RData")

# Species 
# train <- train %>% mutate(c.pip = ifelse(Species == "CULEX PIPIENS", 1, 0), 
#                           c.res = ifelse(Species == "CULEX RESTUANS", 1, 0),
#                           c.pip.c.res = ifelse(Species == "CULEX PIPIENS/RESTUANS", 1, 0), 
#                           c.ter = ifelse(Species == "CULEX TERRITANS", 1, 0),
#                           c.oth = ifelse(!(Species %in% c("CULEX PIPIENS", "CULEX RESTUANS", "CULEX PIPIENS/RESTUANS", "CULEX TERRITANS")), 1,0))
# 
# train <- train %>% mutate(Species2 = Species) 





# train$Species2 <- revalue(train$Species2, c("CULEX ERRATICUS" = "OTHER",
#"CULEX SALINARIUS" = "OTHER",
#"CULEX TERRITANS" = "OTHER"))


