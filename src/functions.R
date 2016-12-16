# functions

suppressMessages(library(ROCR))
suppressMessages(library(pROC))

# add_week_avg_mosq <- function(df){
#   df <- left_join(df, weeklyAvgNumMosq, by = "Week")
#   df
# }

fix_species <- function(x){
  x <- gsub("ERRATICUS", "OTHER", x) %>% 
    gsub("SALINARIUS", "OTHER", .) %>% 
    gsub("TARSALIS", "OTHER", .) %>% 
    gsub("UNSPECIFIED CULEX", "CULEX OTHER",.)
}

model.evaluate <- function(actual, predicted){
  pred <- prediction(predicted, actual)
  perf <- performance(pred, "tpr", "fpr")
  plot(perf)
  auc(actual, predicted)
}