# Engineer Training and Testing sets

suppressMessages(library(tidyverse))
train <- read_csv("./data/train.csv")
test <- read_csv("./data/test.csv")
source("./src/05_functions.R")

# Set target variable as logical
train$WnvPresent <- as.logical(train$WnvPresent)

# Create version of target as factor
train$WnvPresent2 <- as.character(train$WnvPresent)
train$WnvPresent2[train$WnvPresent2== "TRUE"] <- "WNV.Pos"
train$WnvPresent2[train$WnvPresent2== "FALSE"] <- "WNV.Neg"
train$WnvPresent2 <- as.factor(train$WnvPresent2)


# Cut non-used variables

train <- select(train, 
                -Address,
                -Block,
                -Street,
                -AddressNumberAndStreet,
                -AddressAccuracy)

test <- select(test, 
               -Address,
               -Block,
               -Street,
               -AddressNumberAndStreet,
               -AddressAccuracy)


# Create Year and Week columns - Summer is distance from highest per week mosquito population
train$Date2 <- as.POSIXlt(train$Date)
train$Year <- train$Date2$year+1900
train$Week <- floor((train$Date2$yday - train$Date2$wday + 7) /7)
train$Week <- as.integer(floor((train$Date2$yday - train$Date2$wday + 7) /7))
train$Summer <- abs(32-train$Week)
train$Date2 <- NULL

test$Date2 <- as.POSIXlt(test$Date)
test$Year <- test$Date2$year+1900
test$Week <- floor((test$Date2$yday - test$Date2$wday + 7) /7)
test$Summer <- abs(32-test$Week)
test$Date2 <- NULL


weeklyAvgNumMosq <- train %>% 
  group_by(Week) %>% 
  summarise(WeekAvgMos = mean(NumMosquitos)) %>% 
  ungroup()


train <- train %>% left_join(weeklyAvgNumMosq, by = "Week")
test <- test %>% left_join(weeklyAvgNumMosq, by = "Week")

train$Species <- fix_species(train$Species)
test$Species <- fix_species(test$Species)

# Add number of duplicate rows for each trap/date as a measure of mosquito count
Mosq_number <- train %>% group_by(Trap, Date) %>% summarise(Mosq_count = sum(NumMosquitos), nrows = n())
train <- left_join(train, Mosq_number, by = c("Trap", "Date"))

testMosq_number <- test %>% group_by(Trap, Date) %>% summarise(nrows = n())
test <- left_join(test, testMosq_number, by = c("Trap", "Date"))


library(caTools)
library(zoo)
# Calculate 3 day / 5 day / 10 day and 20 day average number of rows per trap

fnrollsum <- function (x, win_length) {
  if (length(x) < win_length) {
    rep(NA,length(x)) 
  } else {
    rollsum(x,win_length,align="right",na.pad=TRUE)
  }
}

train <- train %>% group_by(Trap, Year) %>% 
  mutate(nrow.3d = fnrollsum(nrows, 3), 
         nrow.5d = fnrollsum(nrows, 5),
         nrow.10d = fnrollsum(nrows, 10))

test <- test %>% group_by(Trap, Year) %>% 
  mutate(nrow.3d = fnrollsum(nrows, 3), 
         nrow.5d = fnrollsum(nrows, 5),
         nrow.10d = fnrollsum(nrows, 10))

# Back fill the rolling averages with missing data
train$nrow.3d[is.na(train$nrow.3d)] <- train$nrows[is.na(train$nrow.3d)] 
train$nrow.5d[is.na(train$nrow.5d)] <- train$nrow.3d[is.na(train$nrow.5d)]
train$nrow.10d[is.na(train$nrow.10d)] <- train$nrow.5d[is.na(train$nrow.10d)]

test$nrow.3d[is.na(test$nrow.3d)] <- test$nrows[is.na(test$nrow.3d)]
test$nrow.5d[is.na(test$nrow.5d)] <- test$nrow.3d[is.na(test$nrow.5d)]
test$nrow.10d[is.na(test$nrow.10d)] <- test$nrow.5d[is.na(test$nrow.10d)]


save(train, file = "./data/train.RData")
save(test, file = "./data/test.RData")


## Extract trap locations

traps <- train %>% 
  group_by(Trap, Longitude, Latitude) %>% 
  summarise(number =n()) %>% 
  arrange(Trap)

save(traps, file = "./data/traps.RData")

# Species to sparse matrix
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

rm(list = ls())
