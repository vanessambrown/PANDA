sub1 <- readMat(paste0("/Users/timallen/Box/skinner/data/PANDA/Monsters/", "440269/PIT_440269_1_210312_0959_ProcessedData.mat"))


itis <- unlist(sub1$Data[[6]][11])
sum(itis)
