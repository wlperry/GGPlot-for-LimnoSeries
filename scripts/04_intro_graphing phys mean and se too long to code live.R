# # Install Packages -----
# install.packages("tidyverse")
# install.packages("scales")
# install.packages("readxl")
# install.packages("janitor")
# install.packages("patchwork")
# install.packages("plotly")
# install.packages("skimr")

# install.packages("ggThemeAssist")
# install.packages("styler")

# # Load libraries -----
# Libraries loaded only one time ------
# library(ggThemeAssist)
# library(styler)

# # Libraries used each time ---------
# uesed each time
library(tidyverse)
library(scales)
library(readxl)
library(janitor)
library(patchwork)
library(plotly)
library(skimr)

# # Data Munging -----
# read in the file -----
# this data is the average data from lake N2 from 1990 to 1999 in depths 0-2m
# there is a referene and a treatment side of the lake after fertilizaiton was stopped
n2.df <- read_csv("data/n2_summmary_0-2m.csv") %>% clean_names() %>% 
  mutate(date = as_date(date)) 

# Challenge #1 how to get summary data for chlorophyll a ("chl_ug_l") 
# grouped by treatment and year?
# summary data -----
n2.df %>% filter(variable == "chl_ug_l") %>% 
                 group_by(treatment, year) %>% skim(value)

# # Plots sequence -----
# plot of data over time ----
n2.df %>% filter(variable =="chl_ug_l") %>% 
  ggplot(aes(x=year, y=value,  color = treatment)) + 
  geom_point(position = position_jitterdodge(jitter.width = 0.2,  dodge.width=0.5))
  
# Mean and standard error plot -----  
n2.df %>% filter(variable =="chl_ug_l") %>% 
  ggplot(aes(x=year, y=value,  color = treatment )) +   
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "point",
    size=3,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "line", 
    size=1,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun.data = mean_se, na.rm = TRUE,
    geom = "errorbar", linetype = "solid",
    width=0.4,
    position = position_dodge(width=0.5))

# Mean (SE) error plot Colors  -----  
n2.df %>% filter(variable =="chl_ug_l") %>% 
  ggplot(aes(x=year, y=value,  color = treatment )) +   
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "point",
    size=3,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "line", 
    size=1,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun.data = mean_se, na.rm = TRUE,
    geom = "errorbar", linetype = "solid",
    width=0.4,
    position = position_dodge(width=0.5)) +
  labs(x="year", y = "Chlorpphyll a ug/l") +
  scale_color_manual(
    name="Treatment",
    values = c("darkgreen", "blue2"),
    labels = c("Treatment", "Reference")) 

# fix the years on x axis
# now to regraph --- 
# Fix the x axis
n2.df %>% filter(variable =="chl_ug_l") %>% 
  ggplot(aes(x=year, y=value,  color = treatment )) +   
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "point",
    size=3,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "line", 
    size=1,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun.data = mean_se, na.rm = TRUE,
    geom = "errorbar", linetype = "solid",
    width=0.4,
    position = position_dodge(width=0.5)) +
  scale_color_manual(
    name="Treatment",
    values = c("blue2", "darkgreen"),
    labels = c("Reference", "Treatment")) +
  labs(x="year", y = expression(bold("Chlorpphyll a ug l"^-1))) +
  scale_x_continuous(breaks = seq(1990, 1999, by=1)) 


# fancy axis labels - 
# labs(x="year", y = expression(bold("Chlorpphyll a ug l"^-1)))


# # Now to use GG Theme Assist -----
# Here we highlight the code and click addins and ggThemeAssist
n2.df %>% filter(variable =="chl_ug_l") %>% 
  ggplot(aes(x=year, y=value,  color = treatment)) +   
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "point",
    size=3,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "line", 
    size=1,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun.data = mean_se, na.rm = TRUE,
    geom = "errorbar", linetype = "solid",
    width=0.4,
    position = position_dodge(width=0.5)) +
  labs(x="year", y = expression(bold("Chlorpphyll a ug l"^-1))) +
  scale_x_continuous(breaks = seq(1990, 1999, by=1)) +
  scale_color_manual(
    name="Treatment",
    values = c("blue2", "darkgreen"),
    labels = c("Reference", "Treatment")) 




# Save your own theme ------
theme_gleon <- function(base_size = 14, base_family = "Helvetica")
{
  theme(
    # https://ggplot2.tidyverse.org/reference/theme.html
    # plot stuff
    plot.title = element_text(size = 18, face = "bold"), 
    panel.background = element_rect(fill = NA, linetype = "solid"), 
    plot.background = element_rect(fill = "white", linetype = "solid"), 
    panel.grid.major = element_line(linetype = "blank"),
    panel.grid.minor = element_line(linetype = "blank"),
    # Axis Stuff
    axis.line = element_line(linetype = "solid", colour = "black"),
    axis.ticks = element_line(colour = "black"),
    axis.title = element_text(size = 20, face = "bold"), 
    axis.text = element_text(size = 17, face = "bold", colour = "black"),
    axis.text.x = element_text(size = 14, colour = "black"), 
    axis.text.y = element_text(size = 16, colour = "black"), 
    # Legend stuff
    legend.text = element_text(size = 14, face = "bold"), 
    legend.title = element_text(size = 18, face = "bold"), 
    legend.key = element_rect(fill = NA),
    legend.key.width = unit(1, "cm"),
    legend.background = element_rect(fill = NA)) 
}


# try out set theme -----
n2.df %>% filter(variable =="chl_ug_l") %>% 
  ggplot(aes(x=year, y=value,  color = treatment )) +   
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "point",
    size=3,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "line", 
    size=1,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun.data = mean_se, na.rm = TRUE,
    geom = "errorbar", linetype = "solid",
    width=0.4,
    position = position_dodge(width=0.5)) +
  labs(x="year", y = expression(bold("Chlorpphyll a ug l"^-1))) +
  scale_x_continuous(breaks = seq(1990, 1999, by=1)) +
  scale_color_manual(
    name="Treatment",
    values = c("blue2", "darkgreen"),
    labels = c("Reference", "Treatment")) + 
  theme_gleon()

# try out set theme -----
n2.df %>% filter(variable =="secchi_m") %>% 
  ggplot(aes(x=year, y=value,  color = treatment )) +   
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "point",
    size=3,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "line", 
    size=1,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun.data = mean_se, na.rm = TRUE,
    geom = "errorbar", linetype = "solid",
    width=0.4,
    position = position_dodge(width=0.5)) +
  labs(x="year", y = "Secchi Depth (m)") +
  scale_x_continuous(breaks = seq(1990, 1999, by=1)) +
  scale_color_manual(
    name="Treatment",
    values = c("blue2", "darkgreen"),
    labels = c("Reference", "Treatment")) + 
  theme_gleon()




# Setting other aesthetics ----
# scale_fill_manual(
#   name="Treatment",
#   values = c("darkgreen", "blue2"),
#   labels = c("Treatment", "Reference")) + 
# scale_shape_manual(
#   name="Treatment",
#   values = c(21,22),
#   labels = c("Treatment", "Reference")) + 
# scale_linetype_manual(
#   name="Treatment",
#   values = c("solid", "dotted"),
#   labels = c("Treatment", "Reference")) 


# reorder factors or the legend -----
n2.df <- n2.df %>% mutate(treatment = as.factor(treatment))
# or in base
n2.df$treatment <- as.factor(n2.df$treatment)

# see levels
levels(n2.df$treatment)

# relevel fators
n2.df <- n2.df %>% mutate(treatment = fct_relevel(treatment, "ref", "fert"))

# see NEW levels
levels(n2.df$treatment)


# now to regraph --- 
# note the scale_XXX_manual are now reversed
n2_chla.plot <- n2.df %>% filter(variable =="chl_ug_l") %>% 
  ggplot(aes(x=year, y=value,  color = treatment , linetype = treatment)) +   
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "point",
    size=3,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "line", 
    size=1,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun.data = mean_se, na.rm = TRUE,
    geom = "errorbar", linetype = "solid",
    width=0.4,
    position = position_dodge(width=0.5)) +
  # labs(x="year", y = expression(bold("Chlorpphyll a ug l"^-1))) +
  scale_color_manual(
    name="Treatment",
    values = c("blue2", "darkgreen"),
    labels = c("Reference", "Treatment")) + 
  scale_fill_manual(
    name="Treatment",
    values = c("blue2", "darkgreen"),
    labels = c("Reference", "Treatment")) + 
  scale_shape_manual(
    name="Treatment",
    values = c(22,21),
    labels = c("Reference", "Treatment")) + 
  scale_linetype_manual(
    name="Treatment",
    values = c("dotted", "solid"),
    labels = c("Reference", "Treatment")) 
n2_chla.plot

ggplotly(n2_chla.plot)

# using ggplotly. ---

n2.plot <- n2.df %>% filter(variable =="chl_ug_l") %>% 
  ggplot(aes(x=year, y=value,  color = treatment , linetype = treatment)) +   
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "point",
    size=3,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "line", 
    size=1,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun.data = mean_se, na.rm = TRUE,
    geom = "errorbar", linetype = "solid",
    width=0.4,
    position = position_dodge(width=0.5)) +
  labs(x="year", y = expression(bold("Chlorpphyll a ug l"^-1))) +
  scale_color_manual(
    name="Treatment",
    values = c("blue2", "darkgreen"),
    labels = c("Reference", "Treatment")) + 
  scale_fill_manual(
    name="Treatment",
    values = c("blue2", "darkgreen"),
    labels = c("Reference", "Treatment")) + 
  scale_shape_manual(
    name="Treatment",
    values = c(22,21),
    labels = c("Reference", "Treatment")) + 
  scale_linetype_manual(
    name="Treatment",
    values = c("dotted", "solid"),
    labels = c("Reference", "Treatment")) 

n2.plot

ggplotly(n2.plot)
