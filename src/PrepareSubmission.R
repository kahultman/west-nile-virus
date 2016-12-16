# Sample submission

sample <- read_csv("./data/sampleSubmission.csv")


sample


glm.submission <- select(test, Id, WnvPresent = Wnv.glm.Pred)
sum(is.na(glm.submission$WnvPresent))
write_csv(glm.submission, path = "./data/glm.submission.csv")


glmboos.submission <- select(test, Id, WnvPresent = glmboost.Pred2)
sum(is.na(glmboos.submission$WnvPresent))
write_csv(glmboos.submission, path = "./data/glmboos.submission.csv")


ggplot(data = train, aes(sample = NumMosquitos)) + 
  stat_qq(distribution = stats::qpois, dparams = list(lambda = mean(train$NumMosquitos))) 

save(test, file = "./data/test.RData")
