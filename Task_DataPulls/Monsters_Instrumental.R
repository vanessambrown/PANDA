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
  subdata <- data.frame(reward = unlist(x$Data[[1]][1]), #whether a reward or punishmnet was given
                        response = unlist(x$Data[[1]][2]), # number of presses made
                        ins_stim = unlist(x$Data[[1]][3]), #which stimulus got presented
                        correct = unlist(x$Data[[1]][4]), #whether the correct action was taken
                        rt_first = unlist(x$Data[[1]][5]), #time of first press relative to ins onset
                        instr_resp = unlist(x$Data[[1]][7])) #correct response for each trial
  
  subdata$id <- as.numeric(sub(".*/PIT_(\\d+)_(\\d)_(\\d+)_(\\d+)_ProcessedData.mat", "\\1", i, perl=TRUE)) 
  
  out[[i]] <-  subdata
}

ins_data <- bind_rows(out)


sub1 <- readMat(paste0(os, "440269/PIT_440269_1_210312_0959_ProcessedData.mat"))
sub1$Data[[1]]
