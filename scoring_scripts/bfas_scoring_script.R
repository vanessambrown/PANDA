###download the redcap_in_r package from the DNPL github repo
devtools::install_github("DecisionNeurosciencePsychopathology/redcap_in_r")

###load the packages I need:
library(tidyverse)
library(ggplot2)
library(lubridate)
library(psych)

###set up the panda protocol environment to pull forms from
panda_protocol=list(name="PANDA",
                        redcap_uri='https://www.ctsiredcap.pitt.edu/redcap/api/',
                        token='CD9DCB5E2B863E04684C111F7A6C22F2',
                        forcenewsubinsync=TRUE)

###pull a form
bfas<-bsrc::bsrc.getform(protocol = panda_protocol,online = TRUE,formname = "bfas")

###remove unwanted variables like attention check questions
bfas_data <- select(bfas, -c(redcap_event_name, bfas_check_1, bfas_check_2))

## convert id from character variable to numeric variable
bfas_data$record_id <- as.numeric(bfas_data$record_id)
#filter out the missings we introduced by converting to numeric. This gives us all viable subjects
bfas_data <- bfas_data %>% filter(!is.na(record_id))

#just messing around: reorder the variables, then sort by bfas_39 in descending order
#xx <- bfas_data %>% select(bfas_39, bfas_8_r, bfas_18, everything()) %>% arrange(desc(bfas_39))

# create a list of the items that load on each BFAS aspect
bfas_items <- list(WIT = c("bfas_1_r", "bfas_11", "bfas_21_r", "bfas_31", "bfas_41_r", "bfas_51", "bfas_61", "bfas_71_r", "bfas_81", "bfas_91"), 
                    VOL = c("bfas_6", "bfas_16_r", "bfas_26", "bfas_36_r", "bfas_46", "bfas_56_r", "bfas_66", "bfas_76_r", "bfas_86", "bfas_96"), 
                    COM = c("bfas_2_r", "bfas_12", "bfas_22", "bfas_32_r", "bfas_42", "bfas_52_r", "bfas_62_r", "bfas_72", "bfas_82_r", "bfas_92"), 
                    POL = c("bfas_7", "bfas_17_r", "bfas_27", "bfas_37_r", "bfas_47", "bfas_57", "bfas_67_r", "bfas_77_r", "bfas_87_r", "bfas_97_r"),
                    IND = c("bfas_3", "bfas_13_r", "bfas_23_r", "bfas_33_r", "bfas_43", "bfas_53_r", "bfas_63", "bfas_73", "bfas_83_r", "bfas_93_r"),
                    ORD = c("bfas_8_r", "bfas_18", "bfas_28", "bfas_38", "bfas_48_r", "bfas_58", "bfas_68_r", "bfas_78_r", "bfas_88", "bfas_98"), 
                    ENT = c("bfas_4", "bfas_14_r", "bfas_24_r", "bfas_34_r", "bfas_44", "bfas_54_r", "bfas_64_r", "bfas_74", "bfas_84", "bfas_94"), 
                    ASS = c("bfas_9", "bfas_19", "bfas_29_r", "bfas_39", "bfas_49_r", "bfas_59", "bfas_69", "bfas_79_r", "bfas_89", "bfas_99_r"), 
                    INT = c("bfas_5", "bfas_15_r", "bfas_25", "bfas_35", "bfas_45_r", "bfas_55_r", "bfas_65", "bfas_75", "bfas_85_r", "bfas_95"), 
                    OPE = c("bfas_10", "bfas_20", "bfas_30", "bfas_40", "bfas_50_r", "bfas_60_r", "bfas_70", "bfas_80_r", "bfas_90_r", "bfas_100"))

#score the items
bfas_scored <- scoreItems(bfas_items, bfas_data, min = 1, max = 5)

#look at the output
print(bfas_scored)#, #short = FALSE)

#create new dataframe with the scored scales
bfas_scoredscales <- bfas_scored$scores

describe(bfas_scoredscales)

### In smc, smcs < 0 were set to .0 ### ???

bfas_plot <- pairs.panels(bfas_scoredscales, pch = '.', lm = TRUE, cex.cor = 2)

### make it a table
bfas_scoredscales <- as.data.frame(bfas_scoredscales)

### add the subject ID
bfas_scoredscales$record_id <- bfas_data$record_id

#write csv file
write.csv(bfas_scoredscales, "/Users/shreya/Box/skinner/data/PANDA/Psychosocial/bfas_scored.csv", row.names = FALSE)
