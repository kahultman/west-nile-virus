# Sample submission

sample <- read_csv("./data/sampleSubmission.csv")


sample


glm.submission <- select(test, Id, WnvPresent = Wnv.glm.Pred)
sum(is.na(glm.submission$WnvPresent))

write_csv(glm.submission, path = "./data/glm.submission.csv")

ggplot(data = train, aes(sample = NumMosquitos)) + 
  stat_qq(distribution = stats::qpois, dparams = list(lambda = mean(train$NumMosquitos))) 

