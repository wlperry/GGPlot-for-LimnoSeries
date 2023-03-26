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
z.df <- read_csv("data/zoops_toolik_1985.csv") %>% clean_names() %>% 
  mutate(date = mdy(date))

z.df %>% filter(site =="Toolik") %>% 
  ggplot(aes(date, number, fill=species))+
  geom_bar(aes(fill = species), stat="identity")
  
           