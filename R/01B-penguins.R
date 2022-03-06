### install these packages if you don't already have them
# install.packages('tidyverse')
# install.packages('janitor')
# install.packages('skimr')
# install.packages('rcartocolor')
# install.packages('palmerpenguins')
# install.packages('leafet')
# install.packages('shiny')

## setup ----
# to access package contents, we load packages with library()
library(tidyverse)


## data -----

# we can also access package contents with the :: operator
# this is our example dataset from the palmerpenguins package
palmerpenguins::penguins

# it is a tibble: a df with better properties
class(palmerpenguins::penguins)

# assign so we don't need to load the package
penguins <- palmerpenguins::penguins


## files I/O -----

# write_*
write_csv(x = penguins, 'data/penguins.csv')
rm(penguins)

# read_*
penguins <- read_csv('data/penguins.csv')

# inspect dataset -----

# glimpse - get a look at that data structure
glimpse(penguins)

# there are lots of pre-built packages for data exploration....
# skimr is a good one
skimr::skim(penguins)




## Table operations (20 mins)



