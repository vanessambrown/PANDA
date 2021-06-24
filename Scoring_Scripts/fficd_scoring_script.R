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
fficd<-bsrc::bsrc.getform(protocol = panda_protocol,online = TRUE,formname = "fficd11")

###remove unwanted variables like attention check questions
fficd_data <- select(fficd, -c(redcap_event_name, fficd_check_1, fficd_check_2, fficd_check_3))

## convert id from character variable to numeric variable
fficd_data$record_id <- as.numeric(fficd_data$record_id)
#filter out the missings we introduced by converting to numeric. This gives us all viable subjects
fficd_data <- fficd_data %>% filter(!is.na(record_id))


# create a list of the items that load on each fficd facet
fficd_facets <- list(Aggression = c("fficd_15", "fficd_33", "fficd_48", "fficd_71", "fficd_87", "fficd_102"), 
                     LackOfEmpathy = c("fficd_9", "fficd_28", "fficd_41", "fficd_60", "fficd_65", "fficd_82", "fficd_99",  "fficd_111"), 
                     SelfCenteredness = c("fficd_5", "fficd_21", "fficd_38", "fficd_41", "fficd_60", "fficd_65", "fficd_82",  "fficd_94", "fficd_108", "fficd_113"), 
                     Anger = c("fficd_10", "fficd_30", "fficd_49", "fficd_69", "fficd_86", "fficd_119"),
                     Anxiousness = c("fficd_1", "fficd_22", "fficd_39", "fficd_77", "fficd_97", "fficd_109"),
                     Depressiveness = c("fficd_12", "fficd_34", "fficd_51", "fficd_58", "fficd_72", "fficd_88", "fficd_103",  "fficd_115"), 
                     EmotionalLability = c("fficd_7", "fficd_45", "fficd_55", "fficd_66", "fficd_83", "fficd_112"), 
                     Mistrustfulness = c("fficd_18", "fficd_63", "fficd_95"), 
                     Shame = c("fficd_16", "fficd_36", "fficd_61", "fficd_75", "fficd_90", "fficd_105"), 
                     Vulnerability = c("fficd_4", "fficd_26", "fficd_42", "fficd_79", "fficd_100"),
                     Disorderliness = c("fficd_17", "fficd_50", "fficd_73", "fficd_84", "fficd_118"),
                     Irresponsibility = c("fficd_11", "fficd_27", "fficd_35", "fficd_43", "fficd_47", "fficd_67", "fficd_78",  "fficd_93", "fficd_96", "fficd_110"),
                     Rashness = c("fficd_6", "fficd_29", "fficd_62", "fficd_89", "fficd_104", "fficd_114"),
                     ThrillSeeking = c("fficd_23", "fficd_56", "fficd_120"),
                     EmotionalDetachment = c("fficd_13", "fficd_31", "fficd_44", "fficd_68", "fficd_106", "fficd_116"),
                     SocialDetachment = c("fficd_2", "fficd_24", "fficd_52", "fficd_91"),
                     Unassertiveness = c("fficd_19", "fficd_59", "fficd_80"),
                     Inflexibility = c("fficd_14", "fficd_25", "fficd_32", "fficd_40", "fficd_53", "fficd_70", "fficd_85",  "fficd_98", "fficd_107", "fficd_121"),
                     Perfectionsism = c("fficd_3", "fficd_20", "fficd_37", "fficd_57", "fficd_74", "fficd_92"),
                     Workaholism = c("fficd_8", "fficd_46", "fficd_64", "fficd_81", "fficd_101", "fficd_117"))
                  

#create a list of the items that load on each fficd domain
fficd_domains <- list(Anankastia = c("fficd_14", "fficd_25", "fficd_32", "fficd_40", "fficd_53", "fficd_70", "fficd_85","fficd_98", "fficd_107", "fficd_121","fficd_3", "fficd_20", "fficd_37", "fficd_57", "fficd_74", "fficd_92", "fficd_8", "fficd_46", "fficd_64", "fficd_81", "fficd_101", "fficd_117"),
                     Dissociality = c("fficd_15", "fficd_33", "fficd_48", "fficd_71", "fficd_87", "fficd_102", "fficd_9", "fficd_28", "fficd_41", "fficd_60", "fficd_65", "fficd_82", "fficd_99",  "fficd_111", "fficd_5", "fficd_21", "fficd_38", "fficd_41", "fficd_60", "fficd_65", "fficd_82",  "fficd_94", "fficd_108", "fficd_113"),
                     Disinhibition = c("fficd_17", "fficd_50", "fficd_73", "fficd_84", "fficd_118", "fficd_11", "fficd_27", "fficd_35", "fficd_43", "fficd_47", "fficd_67", "fficd_78",  "fficd_93", "fficd_96", "fficd_110", "fficd_6", "fficd_29", "fficd_62", "fficd_89", "fficd_104", "fficd_114", "fficd_23", "fficd_56", "fficd_120"),
                     Detachment = c("fficd_13", "fficd_31", "fficd_44", "fficd_68", "fficd_106", "fficd_116", "fficd_2", "fficd_24", "fficd_52", "fficd_91", "fficd_19", "fficd_59", "fficd_80"),
                     NegativeAffectivity = c("fficd_10", "fficd_30", "fficd_49", "fficd_69", "fficd_86", "fficd_119", "fficd_1", "fficd_22", "fficd_39", "fficd_77", "fficd_97", "fficd_109", "fficd_12", "fficd_34", "fficd_51", "fficd_58", "fficd_72", "fficd_88", "fficd_103",  "fficd_115", "fficd_7", "fficd_45", "fficd_55", "fficd_66", "fficd_83", "fficd_112", "fficd_18", "fficd_63", "fficd_95", "fficd_16", "fficd_36", "fficd_61", "fficd_75", "fficd_90", "fficd_105"))


#score the items on aspects
fficd_scored_facets <- scoreItems(fficd_facets, fficd_data, min = 1, max = 5)

#score the items on domains
fficd_scored_domains <- scoreItems(fficd_domains, fficd_data, min = 1, max = 5)

#look at the output
print(fficd_scored_aspects)#, #short = FALSE)
print(fficd_scored_domains)#, #short = FALSE)

#create new dataframe with the scored scales
fficd_scoredscales_f <- fficd_scored_facets$scores
fficd_scoredscales_d <- fficd_scored_domains$scores


#make it a table
fficd_scoredscales_f <- as.data.frame(fficd_scoredscales_f)
fficd_scoredscales_d <- as.data.frame(fficd_scoredscales_d)

### add the subject ID
fficd_scoredscales_f$record_id <- fficd_data$record_id
fficd_scoredscales_d$record_id <- fficd_data$record_id


#write csv file
write.csv(fficd_scoredscales_f, "/Users/shreya/Box/skinner/data/PANDA/Psychosocial/fficd_scored_aspects.csv", row.names = FALSE)
write.csv(fficd_scoredscales_d, "/Users/shreya/Box/skinner/data/PANDA/Psychosocial/fficd_scored_domains.csv", row.names = FALSE)

