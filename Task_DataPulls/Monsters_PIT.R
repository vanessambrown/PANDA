library(tidyverse)
library(R.matlab)


#os <- "/Users/timallen/Box/skinner/data/PANDA/Monsters/"
os <- "C:/Users/timot/Box/skinner/data/PANDA/Monsters/"
setwd(paste0(os))

mat_files <- list.files(pattern="*.ProcessedData.mat", recursive=TRUE)

#remove 440269, because she only seems to have 131 responses for some reason
mat_files <- mat_files[!mat_files %in% "440269/PIT_440269_1_210312_0959_ProcessedData.mat"]

out = list()
for (i in mat_files) {
  x <- readMat(paste0(os, i))
  
  subdata <- data.frame(responses = unlist(x$Data[[2]][1]), #number of presses made
                        ins_stim = unlist(x$Data[[2]][2]), # which ins stim
                        correct = unlist(x$Data[[2]][3]), # was it the correct response?
                        pav_stim = unlist(x$Data[[2]][4]), # pav stim
                        pav_val = unlist(x$Data[[2]][5]), # value of the pav stimulus
                        rt_first = unlist(x$Data[[2]][6]), #rt for first response
                        instr_resp = unlist(x$Data[[2]][8])) #correct response for each trial
  
  subdata$id <- as.numeric(sub(".*/PIT_(\\d+)_(\\d)_(\\d+)_(\\d+)_ProcessedData.mat", "\\1", i, perl=TRUE)) 
  subdata <- mutate(subdata, trial = row_number())
  
  out[[i]] <-  subdata
}

pit_data <- bind_rows(out)
