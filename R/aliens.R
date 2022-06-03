##################################################
## Alien Signals
##################################################
#'
#' It's your first day working as an analyst for NASA.
#' Your supervisor has emailed you a dataset with a series of unusual observations
#' that they've recorded over the past few weeks. They're not sure how to
#' interpret this data and are desperate for your help.
#'
#' The metadata included with their dataset reads:
#' - A constant signal has been captured from a distant point in space
#' - There are 25,800 pairs of frequency (x) and amplitude (y) values.
#' - The data were de-noised to remove background and artefacts.
#'
#' *Can you find any patterns in the data?*
#' *Don't worry about coding along, this is just a demo!*
#' -------------------------------------------------------------------------

# uncomment and run this command to get all the packages we'll use today:
# install.packages(c('tidyverse', 'googlesheets4','rmarkdown','leaftlet'))


# load tidyverse package
library(tidyverse)

# signals data shared from my github repo
signals <- read_csv("https://raw.githubusercontent.com/jmoggridge/learn_to_code_seminar/main/data/alien_signals.csv")

# here's what your boss has tried so far...
signals
signals |> glimpse()
signals |> summary()

#' *What should we do to start?*
#' *Put your suggestions in the chat*

ggplot(data = signals, aes(frequency)) +
  geom_histogram()

ggplot(data = signals, aes(frequency, amplitude)) +
  geom_point()






























































