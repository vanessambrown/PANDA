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

#setwd("C:/Users/timot/Box/skinner/data/PANDA/Monsters")
#gitdir <- "C:/Users/timot/Documents/GitHub/PANDA/Plots/"

setwd("~/Box/skinner/data/PANDA/Monsters")
gitdir <- "~/Documents/GitHub/PANDA/Plots/"

#trial-level accuracy plots for individual subjects with loess smoothing
acc_smooth <- ggplot(ins_data, aes(x = trial, y = correct)) + geom_point() + facet_wrap(~ id, nrow = 5) + geom_smooth(method = "loess") +
  scale_x_continuous(breaks = c(0, 40, 80, 120), limits = c(0, 120)) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=18,face="bold"))

#by condition
ins_data <- ins_data %>% group_by(id, instr_resp) %>% mutate(cond_trial = row_number()) %>% ungroup()

ins_data$instr_resp <- factor(ins_data$instr_resp, levels=c("1", "2"), labels=c("Run", "Hide"))

cond_acc <- ggplot(ins_data, aes(x = cond_trial, y = correct, color = as.factor(instr_resp), shape = as.factor(instr_resp))) + 
  geom_point() + facet_wrap(~ id, nrow = 5) + geom_smooth(method = "loess") + 
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18,face="bold")) +
  scale_color_brewer(palette = "Set1")

p1 <- plot_grid(acc_smooth, cond_acc)
save_plot(paste0(gitdir, "Monsters_Subject_Accuracy_Plots.png"), p1, base_height = 10, base_width = 20)

#number of responses by condition
