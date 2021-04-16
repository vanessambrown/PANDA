###set up the panda protocol environment to pull forms from
panda_protocol=list(name="PANDA",
                    redcap_uri='https://www.ctsiredcap.pitt.edu/redcap/api/',
                    token='CD9DCB5E2B863E04684C111F7A6C22F2',
                    forcenewsubinsync=TRUE)

###pull a form
ari<-bsrc::bsrc.getform(protocol = panda_protocol,online = TRUE,formname = "ari")

###remove unwanted variables like redcap event name
ari_data <- select(ari, -c(redcap_event_name))

## convert id from character variable to numeric variable
ari_data$record_id <- as.numeric(ari_data$record_id)

#filter out the missings we introduced by converting to numeric. This gives us all viable subjects
ari_data <- ari_data %>% filter(!is.na(record_id))


#create a key that separates the first 6 items (the total), and the 7th item (impairment)
ari_key <- list(total = c("ari_1","ari_2","ari_3","ari_4","ari_5","ari_6"),impairment = c("ari_7"))

#score the items using the list
ari_scored <- scoreItems(ari_key,ari_data, min = 1, max = 2)

#look at the output
print(ari_scored)#, #short = FALSE)

#create new dataframe with the scored scales
ari_scored_data <- ari_scored$scores

describe(ari_scored_data)

#ari_plot <- pairs.panels(ari_scored_data, pch = '.', lm = TRUE, cex.cor = 2)

### make it a table
ari_scored_data <- as.data.frame(ari_scored_data)

### add the subject ID
ari_scored_data$record_id <- ari_data$record_id

#write csv file
write.csv(ari_scored_data, "/Users/shreya/Box/skinner/data/PANDA/Psychosocial/ari_scored.csv", row.names = FALSE)
