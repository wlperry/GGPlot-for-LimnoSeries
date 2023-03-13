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
z.df <- read_csv("data/zoops_long.csv") %>% clean_names() %>% 
  mutate(date = as_date(date)) 

# Simple zoop graph with no modification
z.df %>% filter(year==1985) %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() 



# ggThemeAssist - how to modify theme settings ------
# what if we wanted a differnet look to the graph before we go further
# highlight code from above and click addins and ggthemeassistant
z.df %>% filter(year==1985) %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() 



# Save your own theme ------
# you can name it as you want and copy your theme settings here
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

# now to try your own them -----
# copy grpah rom above with no theme settings and name the theme as you want
z.df %>% filter(year==1985) %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() +
  theme_light() # change light to your name

# Now to facet grid ----
zoop.plot <- z.df %>% filter(year==1989) %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() +
  theme_gleon() +
  facet_grid(site~.)
zoop.plot



# Now you can animate the grpah to look at specific data
ggplotly(zoop.plot)

# a lot of options but you can do 
zoop.plot <- z.df %>% filter(year==1989) %>% 
  ggplot(aes(date, number, color=species, text = paste('site:', site, sep=" "))) +
  geom_point() +
  geom_line() +
  theme_gleon() +
  facet_grid(site~.)
ggplotly(zoop.plot)

# Make separate graphs -----
z.df %>% distinct(species)

# N2 Fert 
n2f.plot <- z.df %>% filter(year==1989) %>% 
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
               "d_prib", "heter", "holo", "p_ped")) 
n2f.plot

# N2 Ref 
n2r.plot <- z.df %>% filter(year==1989) %>% 
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

toolik.plot <- z.df %>% filter(year==1989) %>% 
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

# Making multipanel graph ---
final.plot <- n2r.plot + theme(axis.title.x = element_blank(),
                axis.text.x  = element_blank(),
                axis.ticks.x = element_blank()) +
n2f.plot + theme(axis.title.x = element_blank(),
                   axis.text.x  = element_blank(),
                   axis.ticks.x = element_blank()) +
toolik.plot +
  plot_layout(ncol = 1, guides = "collect") +
  plot_annotation(tag_levels = "A", tag_suffix = ")") &
  theme(plot.tag = element_text(color = "black", face = 'bold', size = 20))
final.plot


ggsave(final.plot, file ="figures/final_zoop_plot.pdf",
       units = "in",
       width = 8, height = 8)

# Usin Factors
z.df <- z.df %>% 
  mutate(species = as_factor(species),
         site = as_factor(site))

# see levels
levels(z.df$species)

# reorder factors
z.df <- z.df %>% 
  mutate(species = fct_relevel(species, 
     "heter",   "holo",    "p_ped" , "bosmina", 
      "c_scutt", "d_long",  "d_midd" ,  "d_prib"))

reorder.plot <- z.df %>% filter(year==1989) %>% 
  ggplot(aes(date, number, color=species, text = paste('site:', site, sep=" "))) +
  geom_point() +
  geom_line() +
  theme_gleon() +
  facet_grid(site~.)
reorder.plot

toolik_reorder.plot <- z.df %>% filter(year==1989) %>% 
  filter(site == "Toolik") %>% 
  ggplot(aes(date, number, color=species)) +
  geom_point() +
  geom_line() +
  labs(x="Date", y= "Count") +
  scale_color_manual(
    name="Zooplankton Species",
    values = c("darkgreen", "blue2", "red4", "purple3", 
                          "orange3", "yellow4", "steelblue4", "goldenrod4"),
                          labels = c("heter",   "holo",    "p_ped" , "bosmina", 
                                     "c_scutt", "d_long",  "d_midd" ,  "d_prib")) +
  theme_gleon() 
toolik_reorder.plot
         