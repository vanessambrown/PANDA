library(tidyverse)
library(R.matlab)

setwd("~/Box/skinner/data/PANDA/Monsters")

mat_ids <- as.numeric(list.files(path = "/Users/timallen/Box/skinner/data/PANDA/Monsters", recursive=FALSE)) #grab the list of ids
mat_files <- list.files(pattern="*.ProcessedData.mat", recursive=TRUE)

out = list()
for (i in mat_files) {
  x <- readMat(paste0("/Users/timallen/Box/skinner/data/PANDA/Monsters/",
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


### what do we do with total rts? 
id_long <- sort(rep(unique(ins_data$id), 40))
all_rt <- unlist(x$Data[[1]][6])

sub1_inst$presstimest

x <- readMat(paste0("/Users/timallen/Box/skinner/data/PANDA/Monsters/",
                    i))