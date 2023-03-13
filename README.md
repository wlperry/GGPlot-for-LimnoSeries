# GGPlot-for-LimnoSeries

The goal of this workshop is to introduce you to a few packages and approaches that can make data exploration with graphs and graphical presentation of data in lectures and publications easier. We will do this as a live coding exercise using skeleton scripts that will help organize the process but feel free to ask questions that take us off on tangents as this is where we all can learn even more. So I encourage you to stop me at any time and we will have helpers that will be able to take you to a break out room if things are really broken.

The data we will use is from Toolik Lake in the 1990's that is freely available at the links in the citations below.

The packages we will use (install and library commands at bottom of sheet) - I use a core set of packages that seem to make life a lot easier. These are installed one time and run at the start of every script:

-   tidyverse - all of the ggplot, dplyr, lubridate and other Whickham tools
-   scales - allows better manipulation of the x and y scales
-   readxl - read in excel files
-   janitor - does a lot but most importantly cleans the names of the variables
-   patchwork - allows placing multiple graphs on one page and annotating
-   plotly - the part I use is ggplotly that animates graphs
-   skimr - simple summary states in a tidy way

These packages are installed one time and run only once as they load a menu item in Addins in the tool bar in RStudio: These packages are:

-   ggThemeAssist - allows you to manipulate the themes of graphs in ggplot
-   styler - allows you to quickly reformat the code so its readable

# Working with themes

This will be script 01_intro_script in the scripts folder. The goal of this is how to:

-   import a file and fix the headers
-   make a simple graph
-   set the colors, fills, line types, shapes
-   set the themes settings we want with ggThemeAssist
-   save a theme for use later on

# Multipanel Graphs

### Citation for data

Giblin, A. and G. Kling. 2019. Chlorophyll a and primary productivity data for various lakes near Toolik Research Station, Arctic LTER. Summer 1990 to 1999. ver 4. Environmental Data Initiative. <https://doi.org/10.6073/pasta/1b1538449340e68760cf86d92d7082de> (Accessed 2023-03-13).

Giblin, A. and G. Kling. 2016. Physical and chemical data for various lakes near Toolik Research Station, Arctic LTER. Summer 1990 to 1999 ver 4. Environmental Data Initiative. <https://doi.org/10.6073/pasta/1fd85582de93a281e5e5d3b80df97b52> (Accessed 2023-03-13).

Budy, P., C. Luecke, and J. O'Brien. 2016. Zooplankton density for lake samples collected near Toolik Lake Arctic LTER in the summer from 1983 to 1992. ver 4. Environmental Data Initiative. <https://doi.org/10.6073/pasta/e711d62032f0b78b9a91070a38f2b43f> (Accessed 2023-03-13).

# Appendix

Here are the
