library(tidyverse)
library(R.matlab)

#os <- "/Users/timallen/Box/skinner/data/PANDA/Monsters/"
os <- "C:/Users/timot/Box/skinner/data/PANDA/Monsters/"
setwd(paste0(os))

mat_files <- list.files(pattern="*.ProcessedData.mat", recursive=TRUE)

out = list()
for (i in mat_files) {
  x <- readMat(paste0(os,
                      i))
  stim <- data.frame(x$Data[[4]][1])
  subdata <- data.frame(stim1 = stim[1,], #Pav stimulus shown
                        stim2 = stim[2,], #Pav stimulus shown
                        query_resp = unlist(x$Data[[4]][2]), # choice made
                        correct = unlist(x$Data[[4]][3])) #did they choose the high-value stimulus?
  subdata$id <- as.numeric(sub(".*/PIT_(\\d+)_(\\d)_(\\d+)_(\\d+)_ProcessedData.mat", "\\1", i, perl=TRUE)) 
  subdata <- mutate(subdata, trial = row_number())
  
  out[[i]] <-  subdata
}


query_data <- bind_rows(out)
############################

x <- readMat(paste0(os,
                    "440303/PIT_440303_1_210422_1728_ProcessedData.mat"))
stim <- matrix(unlist(x$Data[[4]][1]), ncol = 2, byrow = TRUE)
subdata <- data.frame(stim1 = stim[,1], #Pav stimulus shown
                      stim2 = stim[,2], #Pav stimulus shown
                      query_resp = unlist(x$Data[[4]][2]), # choice made
                      correct = unlist(x$Data[[4]][3])) #did they choose the high-value stimulus?
subdata$id <- as.numeric(sub(".*/PIT_(\\d+)_(\\d)_(\\d+)_(\\d+)_ProcessedData.mat", "\\1", i, perl=TRUE)) 
subdata <- mutate(subdata, trial = row_number())

out[[i]] <-  subdata

