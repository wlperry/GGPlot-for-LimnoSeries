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



# Load libraries -----
## Libraries loaded only one time ------
# library(ggThemeAssist)
# library(styler)

# Libraries used each time -----
library(tidyverse)
library(scales)
library(readxl)
library(janitor)
library(patchwork)
library(plotly)
library(skimr)

# read in the file -----
t.df <- read_excel("data/backup/toolik_n2_physchem_90s.xlsx", na = ".") %>% clean_names() %>% 
  mutate(site = tolower(site)) %>% 
  mutate(year = year(date), month = month(date))

# separate sites -----
# select only lake N2 ref and fert   
n2.df <- t.df %>% filter(site == "n2 fert" | site =="n2 ref") %>% 
  separate(site, c("site", "treatment")) %>% 
  select(site, treatment, date, year, month, everything())

# Select toolik lake
toolik.df <- t.df %>% filter(site =="toolik") %>% 
  select(site, date, year, month, everything())

# Transform files to long format---
# Lake N2
n2_long.df <- n2.df %>% 
  pivot_longer(
    cols=-c(site, treatment, date, year, month, depth_m),
    names_to = "variable",
    values_to = "value")

# toolik to long format
toolik_long.df <- toolik.df %>% 
  pivot_longer(
    cols=-c(site, date, year, month, depth_m),
    names_to = "variable",
    values_to = "value")

# get a quick summary of data ----
# do means of top 2 meters for N2
n2_summary_0_2.df <- n2_long.df %>% 
  filter(depth_m < 3) %>% 
  group_by(site, treatment, date, year, month,  variable) %>% 
  summarize(value = mean(value, na.rm=TRUE))

# do top 2 meters for Toolik Lake
toolik_summary_0_2.df <- toolik_long.df %>% 
  filter(depth_m < 3) %>% 
  group_by(site, date, year, month,  variable) %>% 
  summarize(value = mean(value, na.rm=TRUE))

# save the files ----
write_csv(n2_summary_0_2.df, file = "data/n2_summmary_0-2m.csv")
write_csv(toolik_summary_0_2.df, file = "data/toolik_summmary_0-2m.csv")
write_csv(n2_long.df, file = "data/n2_long.csv")
write_csv(toolik_long.df, file = "data/toolik_long.csv")


# Zoop data munging ---

z.df <- read_excel("data/backup/toolok_n2_zoops_90s.xlsx" , na=".",
                   sheet = "Data") %>% 
  clean_names() %>% 
  select(-d_pulex, -eurycercus) %>% 
  mutate(year= year(date)) %>% 
  mutate(date=as_date(date)) %>% 
  filter(year ==1985)

# z.df <- z.df  %>% 
#   filter(site == "Toolik")

# convert to long format
z_long.df <- z.df %>% 
  pivot_longer(
    cols = -c("site", "tow_type", "depth_m", "date", "year"),
    names_to = "species",
    values_to = "number") 



# do the mean of the species to reduce the duplicates
z_long.df <- z_long.df %>% 
   group_by(site, depth_m, date, year, species ) %>% 
  summarize(number = mean(number, na.rm=TRUE)) 


z_long_85.df <- z_long.df %>% 
  filter(year==1985)

# write out the files
write_csv(z_long_85.df, file="data/zoops_toolik_1985.csv")
write_csv(z_long.df, file="data/zoops_long.csv")
  
