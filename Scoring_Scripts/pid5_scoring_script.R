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
pid5<-bsrc::bsrc.getform(protocol = panda_protocol,online = TRUE,formname = "pid5")

###remove unwanted variables like attention check questions
pid5_data <- select(pid5, -c(redcap_event_name, pid_check_1, pid_check_2))

## convert id from character variable to numeric variable
pid5_data$record_id <- as.numeric(pid5_data$record_id)
#filter out the missings we introduced by converting to numeric. This gives us all viable subjects
pid5_data <- pid5_data %>% filter(!is.na(record_id))

# create a list of the the traits and domains (ask Tim about warning message screenshotted)
pid5_traits <- list(Anhedonia = c("pid_9","pid_11","pid_43","pid_65"), 
                   Anxiousness = c("pid_24","pid_36","pid_48","pid_78"), 
                   Attention_Seeking = c("pid_23","pid_77","pid_87","pid_97"), 
                   Callousness = c("pid_7","pid_62","pid_72","pid_82"),
                   Deceitfulness = c("pid_18","pid_51","pid_95","pid_99"),
                   Depressivity = c("pid_26","pid_60","pid_70","pid_74"), 
                   Distractibility = c("pid_39","pid_49","pid_55","pid_91"), 
                   Eccentricity = c("pid_10","pid_22","pid_61","pid_94"), 
                   Emotional_Lability = c("pid_41","pid_53","pid_71","pid_81"), 
                   Grandiosity = c("pid_14","pid_37","pid_85","pid_90"),
                   Hostility = c("pid_12","pid_31","pid_66","pid_75"),
                   Impulsivity = c("pid_2","pid_5","pid_6","pid_8"),
                   Intimacy_Avoidance = c("pid_29","pid_40","pid_56","pid_93"),
                   Irresponsibility = c("pid_47","pid_64","pid_68","pid_76"),
                   Manipulativeness = c("pid_35","pid_44","pid_69","pid_100"),
                   Perceptual_Dysregulation = c("pid_15","pid_63","pid_88","pid_98"),
                   Perseveration = c("pid_19","pid_25","pid_32","pid_46"),
                   Restricted_Affectivity = c("pid_28","pid_30","pid_73","pid_83"),
                   Rigid_Perfectionism = c("pid_33","pid_42","pid_80","pid_89"),
                   Risk_Taking = c("pid_13","pid_16","pid_21","pid_67"),
                   Separation_Insecurity = c("pid_17","pid_45","pid_58","pid_79"),
                   Submissiveness = c("pid_3","pid_4","pid_20","pid_92"),
                   Suspiciousness = c("pid_1","pid_38","pid_50","pid_86"),
                   Unusual_Beliefs_Experiences = c("pid_34","pid_54","pid_59","pid_96"),
                   Withdrawal = c("pid_27","pid_52","pid_57","pid_84"))

#add additional facets for each domain
#pid5_domains <- list(Negative_Affect = c("Emotional_Lability","Anxiousness","Separation_Insecurity"),
                     #Detachment = c("Withdrawal","Anhedonia","Intimacy_Avoidance"),
                     #Antagonism = c("Manipulativeness","Deceitfulness","Grandiosity"),
                     #Disinhibition = c("Irresponsibility","Impulsivity","Distractibility"),
                     #Psychoticism = c("Unusual_Beliefs_Experiences","Eccentricity","Perceptual_Dysregulation"))
                   
#score the items based on traits
pid5_traits_scored <- scoreItems(pid5_traits, pid5_data, min = 0, max = 3, delete = FALSE)

#score the items based on domains
#pid5_domains_scores <- scoreItems(pid5_domains, pid5_data, min = 0, max = 4, delete = FALSE)

#look at the output
print(pid5_traits_scored)#, #short = FALSE)

#create new dataframe with the scored scales
pid5_traits_scored_table <- pid5_traits_scored$scores

describe(pid5_traits_scored_table)
 

### make it a table
pid5_traits_scored_table <- as.data.frame(pid5_traits_scored_table)

### add the subject ID
pid5_traits_scored_table$record_id <- pid5_data$record_id

#write csv file
write.csv(pid5_traits_scored_table, "/Users/shreya/Box/skinner/data/PANDA/Psychosocial/pid5_scored_traits.csv", row.names = FALSE)
