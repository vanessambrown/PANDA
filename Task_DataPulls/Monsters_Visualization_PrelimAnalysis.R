setwd("C:/Users/timot/Box/skinner/data/PANDA/Monsters")
gitdir <- "C:/Users/timot/Documents/GitHub/PANDA/Plots/"
#setwd("~/Box/skinner/data/PANDA/Monsters")
#gitdir <- "~/Documents/GitHub/PANDA/Plots/"

if (!require(pacman)) { install.packages("pacman"); library(pacman) }
p_load(tidyverse, psych, stats, ggplot2, emmeans, ggeffects, magrittr, sjmisc, splines, nlme, lme4, ggcorrplot, cowplot, viridis) 

#check out the instrumental data first

ins_data$instr_resp <- factor(ins_data$instr_resp, levels=c("1", "2"), labels=c("Run", "Hide"))

#trial-level accuracy plots for individual subjects with loess smoothing
acc_smooth <- ggplot(ins_data, aes(x = trial, y = correct)) + geom_point() + facet_wrap(~ id, nrow = 5) + geom_smooth(method = "loess") +
  scale_x_continuous(breaks = c(0, 40, 80, 120), limits = c(0, 120)) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=18,face="bold"))

#by condition
ins_data <- ins_data %>% group_by(id, instr_resp) %>% mutate(cond_trial = row_number()) %>% ungroup()

cond_acc <- ggplot(ins_data, aes(x = cond_trial, y = correct, color = as.factor(instr_resp), shape = as.factor(instr_resp))) + 
  geom_point() + facet_wrap(~ id, nrow = 5) + geom_smooth(method = "loess") + 
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18,face="bold")) +
  scale_color_brewer(palette = "Set1")

p1 <- plot_grid(acc_smooth, cond_acc)
save_plot(paste0(gitdir, "Monsters_Subject_Accuracy_Plots.png"), p1, base_height = 10, base_width = 20)

#mean number of presses per condition
ins_data %>% group_by(instr_resp) %>% summarize(mean_resp = mean(response, na.rm = T)) %>% ungroup()

#mean number of presses per condition, correct v. incorrect
m_resp <- ins_data %>% filter(!is.na(reward)) %>% group_by(instr_resp, correct) %>% summarize(mean_resp = mean(response, na.rm = T)) %>% ungroup()
ggplot(unite(m_resp, col = resp_cond, instr_resp, correct, sep = "_")) + geom_bar(aes(x = resp_cond, y = mean_resp), stat = "identity")


### check out the pit data
pit_data$instr_resp <- factor(pit_data$instr_resp, levels=c("1", "2"), labels=c("Run", "Hide"))

#trial-level accuracy plots for individual subjects with loess smoothing
pit_acc_smooth <- ggplot(pit_data, aes(x = trial, y = correct)) + geom_point() + facet_wrap(~ id, nrow = 5) + geom_smooth(method = "loess") +
  scale_x_continuous(breaks = c(0, 60, 120, 180), limits = c(0, 180)) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=18,face="bold"))

#add pav value as color
pit_data <- pit_data %>% group_by(id, pav_val) %>% mutate(val_trial = row_number()) %>% ungroup()
pit_val_acc <- ggplot(pit_data, aes(x = val_trial, y = correct, color = as.factor(pav_val), shape = as.factor(pav_val))) + geom_point() + facet_wrap(~ id, nrow = 5) + geom_smooth(method = "loess") +
  scale_x_continuous(breaks = c(0, 20, 40, 60), limits = c(0, 60)) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=18,face="bold"))
