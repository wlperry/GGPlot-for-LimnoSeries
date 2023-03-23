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
t.df <- read_csv("data/toolik_long.csv") %>% clean_names() %>% 
  mutate(date = as_date(date))

# plotting data with depth ----
# so you want to plot some data with depth 
# lets select out temp as the example from 1990 in toolik lake
temp.df <- t.df %>% 
  filter(year == 1990) %>% 
  filter(variable == "temp_c")

# now a plot of depth and temp on July 3
temp.df %>% 
  filter(date == ymd("1990-07-03")) %>% 
  ggplot(aes(y=value, x=depth_m)) + 
  geom_point() + 
  geom_line()

# so this looks good - now how to get the temp on the top and depth vertical
# as usual there are a lot of ways
temp.df %>% 
  filter(date == ymd("1990-07-03")) %>% 
  ggplot(aes(y=value, x=depth_m)) + 
  geom_point() + 
  geom_line() +
  coord_flip() 


temp.df %>% 
  filter(date == ymd("1990-07-03")) %>% 
  ggplot(aes(y=value, x=depth_m)) + 
  geom_point() + 
  geom_line() +
  coord_flip() +
  scale_y_reverse()


temp.df %>% 
  filter(date == ymd("1990-07-03")) %>% 
  ggplot(aes(y=value, x=depth_m)) + 
  geom_point() + 
  geom_line() +
  scale_x_reverse() +
  scale_y_continuous(position = "right") +
  coord_flip() 



temp.df %>% 
  filter(date == ymd("1990-07-03")) %>% 
  ggplot(aes(x=value, y=depth_m)) + 
  geom_point() + 
  geom_path() +
  scale_y_reverse() +
  scale_x_continuous(position="top")


# ok but what if you wanted the mean and SE of say july data
# not easy - best way to to do a new table of summary stats 
# then use that for graphing

temp_july.df <- temp.df %>% 
  group_by(depth_m, variable) %>% 
  summarize(mean_temp_c = mean(value, na.rm=TRUE),
            sd_temp = sd(value, na.rm=TRUE), # this is standard deviation
            se_temp = sd(value, na.rm=TRUE)/sqrt(sum(!is.na(.)))) # this is SE with accounting for missing values)

# now the plot
temp_july.df %>%
  ggplot(aes(x = mean_temp_c, y = depth_m)) +
  geom_point() +
  geom_errorbarh(aes(y = depth_m,
      xmin = mean_temp_c - se_temp,
      xmax = mean_temp_c + se_temp ),
    height = 0.9,
    color = "black") +
  geom_path() +
  scale_y_reverse() +
  scale_x_continuous(position = "top")


            