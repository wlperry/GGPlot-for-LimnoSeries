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

# plot of temp with depth
# so lets make a plot of 1990-07-03 for toolik lake of temp vs depth 







# first way to do the depth versus temp plot-----
# so this looks good - now how to get the temp on the top and depth vertical
# as usual there are a lot of ways

# Challenge #1 how can you flip the axes the easiest way? -----
# Use only one new line of code
temp.df %>% 
  filter(date == ymd("1990-07-03")) %>% 
  ggplot(aes(y=value, x=depth_m)) + 
  geom_point() + 
  geom_line() 








# Challenge #2 how do you reverse the y axis? -----
temp.df %>% 
  filter(date == ymd("1990-07-03")) %>% 
  ggplot(aes(y=value, x=depth_m)) + 
  geom_point() + 
  geom_line() +
  coord_flip() 









# Challenge #3 how do you get the x axis on the top? ----
temp.df %>% 
  filter(date == ymd("1990-07-03")) %>% 
  ggplot(aes(y=value, x=depth_m)) + 
  geom_point() + 
  geom_line() +
  coord_flip() +
  scale_x_reverse() 




# Challenge #4 Second way to do the variable with depth plot ----
# In many cases this will not work 
# Geom_ling vs Geom_path ----
# Note that the geom_line() above works ok but it does not really 
# GGplot does some really weird graphing that we will see in the next incarnation
# it does not follow the rules like excel does and we need to use geom_path()
temp.df %>% 
  filter(date == ymd("1990-07-03")) %>% 
  ggplot(aes(x=value, y=depth_m)) + 
  geom_point() 







# Now doing mean and standard error with depths ------
# ok but what if you wanted the mean and SE of say july data
# not easy - best way to to do a new table of summary stats - 
# then use that for graphing

# make a table of Mean and Standard error data------
# this is SE with accounting for missing values)
temp_july.df <- temp.df %>% 
  group_by(depth_m, variable) %>% 
  summarize(mean_temp_c = mean(value, na.rm=TRUE),
            sd_temp = sd(value, na.rm=TRUE), # this is standard deviation
            se_temp = sd(value, na.rm=TRUE)/sqrt(sum(!is.na(.)))) 

# Plotting data from the new mean and SE table-----
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


# Followup if you like Coord_flip----
# Attempt to do without the table - note you need to use the coord_flip 
# in my opinion it can lead to a lot of issues
temp.df %>% 
  filter(month == 7) %>% 
  ggplot(aes(y=value, x=depth_m)) + 
  stat_summary(
    fun=mean, na.rm = TRUE,
    geom = "point",
    size=3,
    position = position_dodge(width=0.5)) +
  stat_summary(
    fun.data = mean_se, na.rm = TRUE,
    geom = "errorbar", linetype = "solid",
    width=0.4,
    position = position_dodge(width=0.5)) +
stat_summary(
  fun=mean, na.rm = TRUE,
  geom = "line", 
  size=1,
  position = position_dodge(width=0.5)) +
  coord_flip() +
  scale_x_reverse() +
  scale_y_continuous(position = "right") 
  
  
  
            