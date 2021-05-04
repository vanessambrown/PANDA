library(tidyverse)
library(R.matlab)

#os <- "/Users/timallen/Box/skinner/data/PANDA/Monsters/"
os <- "C:/Users/timot/Box/skinner/data/PANDA/Monsters/"
setwd(paste0(os))

mat_files <- list.files(pattern="*.ProcessedData.mat", recursive=TRUE)

#mat_files <- mat_files[1]

out = list()
for (i in mat_files) {
  x <- readMat(paste0(os,
                      i))
  stim <- matrix(unlist(x$Data[[4]][1]), ncol = 2, byrow = TRUE)
  subdata <- data.frame(stim1 = stim[,1], #Pav stimulus shown
                        stim2 = stim[,2], #Pav stimulus shown
                        query_resp = unlist(x$Data[[4]][2]), # choice made
                        correct = unlist(x$Data[[4]][3])) #did they choose the high-value stimulus?
  subdata$id <- as.numeric(sub(".*/PIT_(\\d+)_(\\d)_(\\d+)_(\\d+)_ProcessedData.mat", "\\1", i, perl=TRUE)) 
 subdata <- mutate(subdata, trial = row_number())
  
  out[[i]] <-  subdata
}


query_data <- bind_rows(out)
############################

# Note: for the first 27 subjects, we ran the comparesequential.m script for Pav Queries. This has an odd way of scoring whether responses were correct in Part 4, and leads to a lot of missingness as a result. However, the actual stimuli presented and the selection made by the participant are all still recorded correctly, with 5 being the highest value option and 1 being the lowest value option. For choices, 1 = left, 2 = right. Below, I will recompute the "correct" variable so that we don't have missingness for the first 27 subjects (the rest are fine as we switched to compare.m for Part 4)


query_data <- query_data %>% rowwise() %>% mutate(correct_fixed = if_else(stim1 > stim2 & query_resp == 1, 1, if_else(stim2 > stim1 & query_resp == 2, 1, 0))) %>% ungroup()

