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

# Data Munging ----- 
## read in the file -----
z.df <- read_csv("data/zoops_toolik_1985.csv") 

# Challenge # 1 - how you you clean up the column names ----




# Summary stats by lake-----
# what does the data look like? 
 


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Simple zoop graph ----- 
# only for the site Toolik and x = date, y = number and color as species






# Challenge #2 --------
# - how do you change the theme quickly with built in themes? Try it above?
# The goal is to be able to do this with our own theme or set of themes

# ggThemeAssist - how to modify theme settings ------
# what if we wanted a different look to the graph before we go further
# *highlight code below* and click *addins* and *ggThemeAssistant*
z.df %>% filter(site=="Toolik") %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() 











# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# First way to save your own theme ------
# you can name it as you want and copy your theme settings here 
# or modify what is here as it is laid out by section
theme_gleon <- function(base_size = 14, base_family = "Helvetica")
{
  theme(
    # https://ggplot2.tidyverse.org/reference/theme.html
   # font stuff
    text = element_text(family = "Times New Roman"),
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


# Challenge #3------
# now can you use your own theme instead of the classic theme?

# practice with your theme-------
z.df %>%  filter(site=="Toolik") %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() +
  theme_classic() # change light to your name






# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Second way to save themes -----
saved_theme <- theme(
  # https://ggplot2.tidyverse.org/reference/theme.html
  # font stuff
  text = element_text(family = "Times New Roman"),
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

## save it as RDS
saved_theme %>% saveRDS('saved_theme.rds')

#delete the theme object
rm(saved_theme)

## read theme from file
theme_gleon2 <- readRDS('saved_theme.rds')

# Try the second way to do themes ----
z.df %>%  filter(site=="Toolik") %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() 





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Multi panel graphs --------

# Challenge 3 - make a graph of zooplankton by the 3 sites that are there

# How can you make a graph of zoops by the three sites ----
zoop.plot <- z.df %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() +
  theme_gleon()


zoop.plot


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Plotly and animating plots-------
# What if you wanted to look at points and identify what point was what?
# Now you can animate the graph to look at specific data
# Command is ggplotly




















# How to customize what is is the hihglight box
# a lot of options but you can do 
zoop.plot <- z.df %>% 
  ggplot(aes(date, number, color=species, text = paste('site:', site, sep=" "))) +
  geom_point() +
  geom_line() +
  theme_gleon() +
  facet_grid(site~.)
ggplotly(zoop.plot)





# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Make multiplanel graphs with custom separate graphs -----
# what if really want control over the mutipanel graphs

# We can make custom colors for the series
# First we need to get a list of the species
z.df %>% distinct(species)

# Graph of N2 Fert ----
n2f.plot <- z.df %>%
  filter(site == "N2 Fert") %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() +
  labs(x="Date", y= "Count") +
  theme_gleon() +
  scale_color_manual(
    name="Zooplankton Species",
    values = c("darkgreen", "blue2", "red4", "purple3", 
                "orange3", "yellow4", "steelblue4", "goldenrod4"),
    labels = c("bosmina", "c_scutt", "d_long", "d_midd", 
               "d_prib", "heter", "holo", "p_ped")) +
  theme_gleon() 
n2f.plot

# Graph of N2 Ref  -----
n2r.plot <- z.df %>% 
  filter(site == "N2 Cont") %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() +
  labs(x="Date", y= "Count") +
  scale_color_manual(
    name="Zooplankton Species",
    values = c("darkgreen", "blue2", "red4", "purple3", 
               "orange3", "yellow4", "steelblue4", "goldenrod4"),
    labels = c("bosmina", "c_scutt", "d_long", "d_midd", 
               "d_prib", "heter", "holo", "p_ped")) +
  theme_gleon() 
n2r.plot

# Graph of Toolik ------
toolik.plot <- z.df %>% 
  filter(site == "Toolik") %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() +
  labs(x="Date", y= "Count") +
  scale_color_manual(
    name="Zooplankton Species",
    values = c("darkgreen", "blue2", "red4", "purple3", 
               "orange3", "yellow4", "steelblue4", "goldenrod4"),
    labels = c("bosmina", "c_scutt", "d_long", "d_midd", 
               "d_prib", "heter", "holo", "p_ped")) +
  theme_gleon() 
toolik.plot


# USING PATCHWORK TO MAKE THE MULTIPANEL GRAPH - YOU CAN ALSO USE GRID EXTERA
# Making multipanel graph ----













# Save the final plot------
ggsave(final.plot, file ="figures/final_zoop_plot.pdf",
       units = "in",
       width = 8, height = 8)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Further Customization #1 ------

# Challenge #3 -----
# so there is a lot of junk there - and we might what to tighten this up
# what would you want to do?

# Remove the x axis stuff on A and B?
# theme(axis.title.x = element_blank(),
#       axis.text.x  = element_blank(),
#       axis.ticks.x = element_blank()) 











# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Further Customization #2------
# Using Factors to reorder the series ----







# see levels of factors -----
levels(z.df$species)

# reorder factors -----
z.df <- z.df %>% 
  mutate(species = fct_relevel(species, 
     "heter",   "holo",    "p_ped" , "bosmina", 
      "c_scutt", "d_long",  "d_midd" ,  "d_prib"))



# Plot the reordered series ------
reorder.plot <- z.df %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() +
  theme_gleon() +
  facet_grid(site~.)
reorder.plot

# Really trick out the plot ----
toolik_reorder.plot <- z.df %>%
  filter(site == "Toolik") %>%
  ggplot(aes(date, number, color = species)) +
  geom_point() +
  geom_line() +
  labs(x = "Date", y = "Count") +
  scale_color_manual(
    name = "Zooplankton Species",
    values = c(
      "darkgreen", "blue2", "red4", "purple3",
      "orange3", "yellow4", "steelblue4", "goldenrod4"),
    labels = c(
      "Heterocope", "Holopedium", "Polyphemus", "Bosmina",
      "C. scutt", "D. long", "D. midd", "D. pribb") ) +
  theme_gleon() +
  facet_grid(site ~ .)
toolik_reorder.plot
         