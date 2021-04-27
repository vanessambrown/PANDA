library(tidyverse)
library(lme4)
library(stats)
library(ggplot2)
library(emmeans)
library(ggeffects)
library(magrittr)
library(sjmisc)
library(cowplot)
library(splines)
library(psych)
library(nlme)
library(ggcorrplot)


if (!require(pacman)) { install.packages("pacman"); library(pacman) }
p_load(tidyverse, psych, stats, ggplot2, emmeans, ggeffects, magrittr, sjmisc, splines, nlme, ggcorrplot, cowplot, viridis) 

#setwd("~/Box/skinner/data/PANDA/Aversive_GNG")
setwd("C:/Users/timot/Box/skinner/data/PANDA/Aversive_GNG")
gitdir <- "C:/Users/timot/Documents/GitHub/PANDA/Plots/"

AGNG_data <- read_csv("Aversive_GNG_Data.csv")

AGNG_data <- AGNG_data %>% dplyr::select(subj_id, TrialNum, Condition, CorrectResp, CorrResp_eq_NoSound, CuePic_from_dict_raw, sound_fdbk_outcome_raw, sound_fdbk_raw, target_resp.keys_raw, target_resp.rt_raw, trialcorrect_raw)

#check the IDs
AGNG_ids <- AGNG_data %>% group_by(subj_id) %>% summarize(n = n())

#trial-level accuracy plots for individual subjects with loess smoothing
sub_acc_loess <- ggplot(AGNG_data, aes(x = TrialNum, y = trialcorrect_raw)) + geom_point() + facet_wrap(~ subj_id, nrow = 5) + geom_smooth(method = "loess") + theme(axis.text=element_text(size=18), axis.title=element_text(size=18,face="bold"))
save_plot(paste0(gitdir, "Subject_Accuracy_Loess.png"), sub_acc_loess, base_height = 10, base_width = 10)

#by condition and response
AGNG_data <- AGNG_data %>% group_by(subj_id, Condition) %>% mutate(cond_trial = row_number()) %>% ungroup()
AGNG_data <- AGNG_data %>% group_by(subj_id, CorrectResp) %>% mutate(resp_trial = row_number()) %>% ungroup()

cond_acc <- ggplot(AGNG_data, aes(x = cond_trial, y = trialcorrect_raw, color = Condition, shape = Condition)) + 
  geom_point() + facet_wrap(~ subj_id, nrow = 5) + geom_smooth(method = "loess") + 
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18,face="bold")) +
  scale_color_brewer(palette = "Set1")

resp_acc <- ggplot(AGNG_data, aes(x = resp_trial, y = trialcorrect_raw, color = CorrectResp, shape = CorrectResp)) + 
  geom_point() + facet_wrap(~ subj_id, nrow = 5) + geom_smooth(method = "loess") + 
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18,face="bold")) + 
  scale_color_viridis(discrete = TRUE, option = "D")

acc_cond_resp <- plot_grid(cond_acc, resp_acc)
save_plot(paste0(gitdir, "Subject_Accuracy_CondResp.png"), acc_cond_resp, base_height = 8, base_width = 14)

#average accuracy and RT
AGNG_data <- AGNG_data %>% group_by(subj_id) %>% mutate(Subj_Acc = sum(trialcorrect_raw)/max(TrialNum), Subj_TotalCorrect = sum(trialcorrect_raw), Subj_RT = mean(target_resp.rt_raw, na.rm = T)) %>% ungroup()

#plot distribution of accuracy 
accplot <- AGNG_data %>% dplyr::select(subj_id, Subj_Acc) %>% unique()
acc_dist <- ggplot(accplot, aes(x = Subj_Acc)) + geom_histogram(binwidth = .10) + theme_minimal()
save_plot(paste0(gitdir, "Accuracy_Distribution.png"), acc_dist)

#average accuracy in the sample
mean(AGNG_data$Subj_Acc)
sd(AGNG_data$Subj_Acc)

#removing inaccurate subs -- create a vector of the bad subjects and then filter them out
badsubs <- c("440275", "440272")
AGNG_data <- AGNG_data %>% filter(!subj_id %in% badsubs)

#dv: trialcorrect_raw
#model 1: DV and an intercept as a fixed factor in a random intercept model
gmm1 <- glmer(trialcorrect_raw ~ (1 |subj_id), family=binomial, data=AGNG_data)
summary(gmm1)
#model 2: add condition
gmm2 <- glmer(trialcorrect_raw ~ Condition + (1 |subj_id), family=binomial, data=AGNG_data)
summary(gmm2)
#model 3: add response
gmm3 <- glmer(trialcorrect_raw ~ CorrectResp + (1 |subj_id), family=binomial, data=AGNG_data)
summary(gmm3)
#model 4: add condition x response
gmm4 <- glmer(trialcorrect_raw ~ Condition*CorrectResp + (1 |subj_id), family=binomial, data=AGNG_data)
summary(gmm4)

anova(gmm1, gmm2, gmm3, gmm4)

#obtain reference grid
gmm4.rg <- ref_grid(gmm4)
gmm4.rg
#obtain estimated marginal means
emm.acc = emmeans(gmm4, specs = pairwise ~ Condition:CorrectResp, type = "response")
emm.acc

#save the estimated marginal means to a dataframe
accbarplot <- emm.acc$emmeans %>%  as.data.frame()

#change the order of the factor levels for CorrectResp so that go/no-go bars will be in correct positions in the plot
accbarplot$CorrectResp <- factor(accbarplot$CorrectResp, levels = rev(levels(accbarplot$CorrectResp)))

#plot the results
p <- ggplot(data=accbarplot, aes(x=Condition, y=prob, fill=CorrectResp)) + geom_bar(stat="identity", position="dodge") #+ coord_cartesian(ylim=c(.5,.9))

p1 <- p + geom_errorbar(position=position_dodge(1),width=.25, aes(ymax=asymp.UCL, ymin=asymp.LCL),alpha=1) + scale_x_discrete(labels = c('Avoid','Escape')) + coord_cartesian(ylim = c(.5,1)) + scale_fill_manual(values=c("steelblue4", "darkred"), breaks=c("nogo", "go"), labels=c("No-go", "Go")) + labs(y = "Probability") + guides(fill = guide_legend(title = NULL))

p2 <- p1 + theme(axis.text = element_text(size = 12, face = "bold"), axis.title = element_text(size = 14, face = "bold"), legend.text = element_text(size = 12, face = "bold"), legend.background = element_rect(fill = "grey90")) + theme_cowplot(12)
p2
save_plot(paste0(gitdir, "Accuracy_barplot.pdf"), p2)

### plotting trial-level data
subs <- n_distinct(AGNG_data$subj_id)
trialacc <- AGNG_data %>% group_by(TrialNum) %>% summarize(Correct = sum(trialcorrect_raw)) %>% mutate(TrialAccuracy = Correct/ subs) %>% ungroup()

trialacc.plot <- ggplot(trialacc, aes(x = TrialNum, y = TrialAccuracy)) + geom_line() + geom_smooth()

save_plot(paste0(gitdir, "Trial_Accuracy_FullSample.pdf"), trialacc.plot)

######################Reaction Time############################################

#plot distribution of RTs 
rtplot <- AGNG_data %>% dplyr::select(subj_id, target_resp.rt_raw) %>% unique()

rt_dist <- ggplot(AGNG_data, aes(x = target_resp.rt_raw)) + geom_histogram()
save_plot(paste0(gitdir, "RT_Distribution.pdf"), rt_dist)

# will want to have a cutoff for low RTs
AGNG_rtcut <- AGNG_data %>% filter(target_resp.rt_raw > .1)

#model
rt4.lme <- lme(target_resp.rt_raw ~ Condition*CorrectResp, random = ~ 1|subj_id, data=AGNG_rtcut)
summary(rt4.lme)

#obtain reference grid
rt4.rg <- ref_grid(rt4.lme)
rt4.rg
#obtain estimated marginal means
emm.rt = emmeans(rt4.lme, specs = pairwise ~ Condition:CorrectResp, type = "response")
emm.rt

#save the estimated marginal means to a dataframe
rtbarplot <- emm.rt$emmeans %>%  as.data.frame()

#change the order of the factor levels for CorrectResp so that go/no-go bars will be in correct positions in the plot
rtbarplot$CorrectResp <- factor(rtbarplot$CorrectResp, levels = rev(levels(rtbarplot$CorrectResp)))

#plot the results
prt <- ggplot(data=rtbarplot, aes(x=Condition, y=emmean, fill=CorrectResp)) + geom_bar(stat="identity", position="dodge") + coord_cartesian(ylim = c(.6,1.2))
prt1 <- prt + geom_errorbar(position=position_dodge(1),width=.25, aes(ymax=upper.CL, ymin=lower.CL),alpha=1) + scale_x_discrete(labels = c('Avoid','Escape')) + scale_fill_manual(values=c("steelblue4", "darkred"), breaks=c("go", "nogo"), labels=c("Go", "No-go")) + labs(y = "Reaction Time") + guides(fill = guide_legend(title = NULL))
prt2 <- prt1 + theme(axis.text = element_text(size = 12, face = "bold"), axis.title = element_text(size = 14, face = "bold"), legend.text = element_text(size = 12, face = "bold"), legend.background = element_rect(fill = "grey90")) + theme_cowplot(12)
prt2 

save_plot(paste0(gitdir, "RT_barplot.pdf"), prt2)

