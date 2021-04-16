###set up the panda protocol environment to pull forms from
panda_protocol=list(name="PANDA",
                    redcap_uri='https://www.ctsiredcap.pitt.edu/redcap/api/',
                    token='CD9DCB5E2B863E04684C111F7A6C22F2',
                    forcenewsubinsync=TRUE)

###pull a form
rsq<-bsrc::bsrc.getform(protocol = panda_protocol,online = TRUE,formname = "rsq")

###remove unwanted variables like redcap event name
rsq_data <- select(rsq, -c(redcap_event_name))

## convert id from character variable to numeric variable
rsq_data$record_id <- as.numeric(rsq_data$record_id)

#filter out the missings we introduced by converting to numeric. This gives us all viable subjects
rsq_data <- rsq_data %>% filter(!is.na(record_id))

#create items to multiply a and b for each item group, remove old a and b variables
#scoring is a times b and then the mean of each to get rejection sensitivity

rsq_data_score <- rsq_data %>% mutate(
                                "rsq_1" = rsq_1a*rsq_1b_r,
                                "rsq_2" = rsq_2a*rsq_2b_r,
                                "rsq_3" = rsq_3a*rsq_3b_r,
                                "rsq_4" = rsq_4a*rsq_4b_r,
                                "rsq_5" = rsq_5a*rsq_5b_r,
                                "rsq_6" = rsq_6a*rsq_6b_r,
                                "rsq_7" = rsq_1a*rsq_7b_r,
                                "rsq_8" = rsq_8a*rsq_8b_r,
                                "rsq_9" = rsq_9a*rsq_9b_r
                                )

rsq_data_score <- select(rsq_data, c(rsq_1, rsq_2, rsq_3, rsq_4, rsq_5, rsq_6, rsq_7, rsq_8, rsq_9))

#list - rejection sensitivity = rsq_1:rsq_9
rsq_items <- list(rejection_sensitivity = c("rsq_1", "rsq_2", "rsq_3", "rsq_4", "rsq_5", "rsq_6", "rsq_7", "rsq_8", "rsq_9"))

#score the new items - rejection sensitivity
rsq_scored <- scoreItems(rsq_items,rsq_data_score, min = 1, max = 36)

#look at the output
print(rsq_scored)#, #short = FALSE)

#create new dataframe with the scored scales
rsq_scored_data <- rsq_scored$scores

describe(rsq_scored_data)

### make it a table
rsq_scored_data <- round(as.data.frame(rsq_scored_data), digits = 2)

### add the subject ID
rsq_scored_data$record_id <- rsq_data$record_id

#write csv file
write.csv(rsq_scored_data, "/Users/shreya/Box/skinner/data/PANDA/Psychosocial/rsq_scored.csv", row.names = FALSE)
