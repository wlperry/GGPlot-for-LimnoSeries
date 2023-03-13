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
n2.df <- read_csv("data/n2_summmary_0-2m.csv") %>% clean_names() %>% 
  mutate(date = as_date(date))

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
chlor.plot <- n2.df %>% filter(variable =="chl_ug_l") %>% 
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
chlor.plot



# try out set theme -----
secchi.plot <- n2.df %>% filter(variable =="secchi_m") %>% 
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
secchi.plot

# Making multipanel graph ---
chlor.plot + theme(axis.title.x = element_blank(),
                   axis.text.x  = element_blank(),
                   axis.ticks.x = element_blank()) +
  secchi.plot +
  plot_layout(ncol = 1, guides = "collect") +
  plot_annotation(tag_levels = "A", tag_suffix = ")") &
  theme(plot.tag = element_text(color = "black", face = 'bold', size = 20))


