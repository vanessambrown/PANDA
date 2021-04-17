library(tidyverse)
library(R.matlab)
library(ggplot2)


#setwd("~/Box/skinner/data/PANDA/Aversive_GNG")
setwd("C:/Users/timot/Box/skinner/data/PANDA/Aversive_GNG")

# function that will bring the data into r
read_millner <- function(file) {
  fdata <- readLines(file) #read the lines in this file
  desc_line <- which(fdata=="extraInfo") #find the line that starts with "extraInfo" and call it desc_line
  id_line <- grep("subjnum", fdata) #find this character string and call the line it is on the id_line
  if (length(id_line) != 1) { stop("Can't identify subject id in footer in: ", file)} 
  date_line <- grep("date", fdata)
  if (length(date_line) != 1) { stop("Can't identify Mode in footer in: ", file)}
  
  subj_id <- sub("subjnum,", "", fdata[id_line])
  taskdate <- sub("date", "", fdata[date_line])
  if (length(desc_line) != 1) { stop("Can't identify extraInfo line in: ", file) }
  nblanks <- which(fdata == "")
  nblanks <- sum(nblanks < desc_line)
  
  fcsv <- read.csv(file, fileEncoding="UTF-8-BOM", nrow=desc_line - 2 - nblanks) # -1 for row before descriptions, -1 for header line
  fcsv$subj_id <- subj_id
  fcsv$date <- taskdate
  return(fcsv)
}

## for loop to execute function over all csvs
ldf <- list() # creates a list

listcsv <- list.files(pattern = "*.\\dtrials.csv", recursive = TRUE) # creates the list of all the csv files in the directory -- reg exp says give me all the files with trials and a number preceding it (Which excludes the practice trial files)
for (k in 1:length(listcsv)){
  ldf[[k]] <- read_millner(listcsv[k])
}

#check dimensions of each person's data
dim_list <- lapply(ldf, dim)
#save length of the list as an object
nlist <- length(dim_list)
#convert list to df
dim_df <- data.frame(matrix(unlist(dim_list), nrow=nlist, byrow=T),stringsAsFactors=FALSE)
#make rownames a variable
dim_df$subs <- rownames(dim_df)
#print subs in ldf that have the wrong number of dimensions
dim_df %>% filter(X1 != 160 | X2 != 56) ### should be 160 * 56

#merge the dataframes in the list
millner_data <- rbindlist(ldf)

#check IDs
unique(millner_data$subj_id)

#grab just the numeric component of the subject id column and the CuePic_from_dict_raw column
millner_data <- millner_data %>% mutate(subj_id = parse_number(subj_id), CuePic_from_dict_raw = parse_number(as.character(CuePic_from_dict_raw)))

# remove quotes from sound_fdbk_outcome_raw & target_resp.keys_raw columns
millner_data$sound_fdbk_outcome_raw <- gsub("'", "", millner_data$sound_fdbk_outcome_raw, fixed = TRUE)
millner_data$target_resp.keys_raw <- gsub("'", "", millner_data$target_resp.keys_raw, fixed = TRUE)

#remove comma from date column
millner_data$date <- gsub(",", "", millner_data$date, fixed = TRUE)
millner_data$date <- as.POSIXct(millner_data$date, "%Y_%b_%d_%H%M", origin = "1960-01-01", tz = "GMT")

millner_data <- dplyr::select(millner_data, subj_id, date, everything())

## define a helper function to turn all blanks into NAs
empty_as_na <- function(x){
  if("factor" %in% class(x)) x <- as.character(x) ## since ifelse wont work with factors
  ifelse(as.character(x)!="", x, NA)
}

millner_data <- millner_data %>% mutate_at(vars(-one_of(c("subj_id", "date"))), list(empty_as_na))

##exclude non-real data
millner_data <- millner_data %>% dplyr::filter(subj_id != 9999 & subj_id != 8888)
#sanity check
unique(millner_data$subj_id)
n_distinct(millner_data$subj_id)

write.csv(millner_data, "Aversive_GNG_Data.csv", row.names = FALSE)
