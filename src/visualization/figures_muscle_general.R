# Copyright (c) 2021 Adam M. Wawro. All rights reserved.
#
# Licensed under the MIT license. See the LICENSE file in the project
# root directory for full license information.
# 
# ======================================================================

library(tidyverse)
library(ggpubr)


data_WT_G <- read_csv("WT_G_3-months_20x_composite.csv") %>%
  mutate(age = "3m", genotype = "WT")
data_WT_D <- read_csv("WT_D_6-months_20x_composite.csv") %>%
  mutate(age = "6m", genotype = "WT")
data_KO_E <- read_csv("KO_E_3-months_20x_composite.csv") %>%
  mutate(age = "3m", genotype = "KO")
data_KO_C <- read_csv("KO_C_6-months_20x_composite.csv") %>%
  mutate(age = "6m", genotype = "KO")

data_all <- bind_rows(data_WT_G, data_WT_D, data_KO_E, data_KO_C)

comparisons <- list(c("WT_3m", "KO_3m"), c("WT_6m", "KO_6m"))

data_all %>%
  mutate(genotype = fct_rev(genotype)) %>%
  group_by(Mouse_ID, age, genotype) %>%
  summarize(mean_feret = mean(Feret)) %>%
  ggplot(aes(x = interaction(genotype, age, sep = "_"), y = mean_feret)) +
  stat_summary(geom = "bar", fun = mean, width = 0.5, fill = NA, color = "black", size = 0.25) +
  stat_summary(geom = "errorbar", fun.data = mean_se, width = 0.25, size = 0.25) +
  stat_compare_means(comparisons = comparisons, method = "t.test", size = 3) + 
  theme_bw() +
  labs(x = NULL, y = "maximum Feret diameter / \u00B5M")
ggsave("muscle_Feret.svg", width = 55, height = 55, units = "mm", scale = 1, device = pdf)

data_all %>%
  mutate(genotype = fct_rev(genotype)) %>%
  group_by(Mouse_ID, age, genotype) %>%
  summarize(mean_area = mean(Area)) %>%
  ggplot(aes(x = interaction(genotype, age, sep = "_"), y = mean_area)) +
  stat_summary(geom = "bar", fun = mean, width = 0.5, fill = NA, color = "black", size = 0.25) +
  stat_summary(geom = "errorbar", fun.data = mean_se, width = 0.25, size = 0.25) +
  stat_compare_means(comparisons = comparisons, method = "t.test", size = 3) + 
  theme_bw() +
  labs(x = NULL, y = "cross-sectional area / \u00B5m\u00B2")
ggsave("muscle_area.svg", width = 55, height = 55, units = "mm", scale = 1, device = pdf)
