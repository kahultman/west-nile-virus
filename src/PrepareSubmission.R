# Sample submission

sample <- read_csv("./data/sampleSubmission.csv")


sample


glm.submission <- select(test, Id, WnvPresent = Wnv.glm.Pred)
sum(is.na(glm.submission))

write_csv(glm.submission, path = "./data/glm.submission.csv")

