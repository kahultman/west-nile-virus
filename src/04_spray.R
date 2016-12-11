# Load Spray data
library(tidyverse)

spray <- tbl_df(read.csv("./data/spray.csv"))

spray$Date <- as.Date(spray$Date, "%Y-%m-%d")

spray$Date2 <- as.POSIXlt(spray$Date)
spray$Year <- spray$Date2$year+1900
spray$Week <- floor((spray$Date2$yday - spray$Date2$wday + 7) /7)
spray$Date2 <- NULL


save(spray, file = "./data/spray.RData")


