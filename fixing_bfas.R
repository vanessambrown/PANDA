### Here's how we fixed the scores on the BFAS

### Make a function to reverse the scores: (max score + 1) - (score)
fix_bfas <- function(x) (6-x)

### Use this function  with mutate for all the item variables (those that start with "bfas") (to exclude the ID number and other things)
bfas_fixed <- bfas %>% mutate_at(vars(starts_with("bfas")), fix_bfas)
                  
### Write into a csv separate from the old (unfixed) data
write.csv(bfas_fixed, "/Users/shreya/Box/skinner/data/PANDA/Psychosocial/bfas_raw_scores_fixed.csv", row.names = FALSE)

