## Welcome to Tutorial 1 - Table Operations! -----

### install these packages if you don't already have them
# install.packages('tidyverse')
# install.packages('palmerpenguins')
# install.packages('skimr')
# install.packages('janitor')
# install.packages('rcartocolor')


#' this tutorial introduces the reader to data analysis with the `tidyverse` family of packages.
#' We start with reading and writing data and performing basic table operations, then transform  and summarize data for tables and figures.

#' We'll use `readr::` functions for In / Out
#'
#' For `dplyr`, we will:
#'
#' - Pick columns with `select()`
#' - subset rows with `filter()` and `slice()`
#' - Modify and Create data with `mutate()`
#' - Reduce multiple values to a single result with `summarise()`
#' - Split data with `group_by()`
#' - remove duplicates with `distinct()`
#' - sort tables with `arrange()`


#' __This text means: 'Now you give it a try!'__




## setup -------------------------------------------------------------
# to access package contents, we load packages with library()
library(tidyverse)


## data --------------------------------------------------------------

# we can also access package contents with the :: operator
# this is our example dataset from the palmerpenguins package
palmerpenguins::penguins
?palmerpenguins::penguins

# it is a tibble: a df with better properties
class(palmerpenguins::penguins)

# assign so we don't need to load the package
penguins <- palmerpenguins::penguins

##' Files I/O ---------------------------------------------------------

#' `readr::write_*` family of functions
readr::write_csv(x = penguins, 'data/penguins.csv')
rm(penguins)

#' `readr::read_*` family of functions
penguins <- read_csv('data/penguins.csv', skip = 0, trim_ws = T)

##' Inspect dataset ---------------------------------------------------

#' glimpse - get a look at that data structure
glimpse(penguins)

#' Tidy data / tibbles:
#' - each observation (penguin) is a row
#' - each variable (eg. species, sex) is a column
#' - dataset is 'rectangular'

# there are lots of pre-built packages for data exploration....
# skimr is a good one
skimr::skim(penguins)

##' the pipe: `|>` or `%>%` !
# passes LHS to first argument of RHS,
penguins |> View()


## `dplyr` ~ Table operations ----------------------------------------
# https://dplyr.tidyverse.org/

# open up the cheatsheet: https://github.com/rstudio/cheatsheets/blob/main/data-transformation.pdf

# There are five main operations:
# select - choose specific columns
# filter - choose specific rows
# mutate - modify a column or create a new column
# summarise -


#' Subset columns by name with `select(...)` -----

penguins |> select(species, sex, year)

#' __ Create a subset with only the length variables with '_mm' suffix__
# penguins_len <- ...your code here....


#' tidy-selectors for handling multiple columns:
#' `contains`, `starts_with`, `ends_with`, `matches`, `where`, `everything`,
#' var1:var2
# penguins |> select(....)

#' subset rows by their values with `filter(...)` ------

penguins |> filter(sex == 'male')
penguins |> filter(sex == 'male', bill_length_mm > 39.5)

# we can use is.*() functions to test whether a vector/value is a certain class
penguins |> filter(is.na(bill_length_mm))
penguins |> select(where(~is.character(.x)))

# ?Comparison
# ?base::Logic

#' __ Subset the penguins that are missing 'sex' (NA) __


#' __ Subset the penguins from Dream and Briscoe islands __
#' recall the logical 'OR' operator: |


#' Membership test: `%in%`
'x' %in% c('x', 'y', 'z')

# There are other ways to subset data:

#' eliminate any duplicated rows (super-useful!)
penguins |> distinct()
tibble(x = c(1,1), y = c(2,2)) |> distinct()

# by position with `slice`
penguins
penguins |> slice(2:4)

#' __ Why might it be bad to use position to select values though? __
#' 'Magic numbers'....

# top rows
penguins |> slice_head(n = 3)
# bottom rows
penguins |> slice_tail(n = 3)
# random subset
penguins |> slice_sample(n = 10)


#' Modify and Create data with `mutate` -----
# df |> mutate(new_variable = ...)

# convert body mass to kilograms
penguins |>
  select(body_mass_g) |>
  mutate(body_mass_kg = body_mass_g / 1000)

# make the 'sex' and 'island' columns into factors.
penguins |>
  select(where(is.character)) |>
  mutate(
    sex = as_factor(sex),
    island = as_factor(island)
  ) |>
  select(where(is.factor))

#' use `across()` to do an operation on multiple columns using tidy-select
penguins |>
  glimpse() |>
  mutate(across(
    .cols = where(~is.character(.x)),
    .fns = ~as_factor(.x)
  )) |>
  glimpse()

#' __Convert all columns ending in '_mm' to cm__



# Summarise  --------------------------------------------------------

#' Reduce multiple values to a single result with `summarise(...)`
penguins |> summarise(mean_bill_len = mean(bill_length_mm))

#' Notice that NA values are contagious!
penguins |>
  filter(!is.na(bill_length_mm)) |>
  summarise(mean_bill_len = mean(bill_length_mm))

#' We usually tell summary functions to remove NA's because of this!
penguins |>
  summarise(mean_bill_len = mean(bill_length_mm, na.rm = T))


#' Behold! The awesome power of `group_by(...)`:
penguins |>
  group_by(species) |>
  summarise(mean_bill_len = mean(bill_length_mm, na.rm = T))


#' __ Get the mean and sd of 'body_mass_g', for penguins grouped by 'island' and 'sex' __


#' we can apply a function or set of functions across columns
penguins |>
  group_by(sex, island) |>
  summarise(
    across(
      .names = "{str_remove(.col, '_g')}_{.fn}",
      .cols = c(body_mass_g, flipper_length_mm),
      .fns = list(
        mean = ~mean(.x, na.rm=T),
        sd = ~sd(.x, na.rm=T)
      ),
    ),
    .groups = 'drop'
  )

# grouping also works when we do 'mutate'
penguins |>
  select(species, sex, body_mass_g) |>
  group_by(species, sex) |>
  mutate(body_mass_mean = mean(body_mass_g, na.rm = T))


# use ungroup to remove groups...
penguins |> group_by(sex) |> ungroup()

#' Quick discrete variable summaries with `count()`
penguins |> count(island, sex, year)

## Arrange
# sort the dataset based on values (smallest to largest)
# use desc() to reverse (largest to smallest)
penguins |> arrange(species, desc(bill_length_mm))




## Plotting with ggplot2



# ggplot(data, aes(...)) + geom_* <+ facet_*> +  scale_* + labs + theme_*

# scatter
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point(size = 0.75, alpha = 0.8)

# scatter
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm,
             size = body_mass_g,
             color = species)) +
  geom_point(alpha = 0.4)


# barplot
penguins |>
  count(island, sex) |>
  ggplot() +
  geom_col(aes(y = island, x = n, fill = sex))

# univariate distributions
penguins |>
  ggplot(aes(x = flipper_length_mm, fill = sex)) +
  geom_histogram(color = 'white', size = 0.1)
penguins |>
  ggplot(aes(x = flipper_length_mm, color = sex)) +
  geom_boxplot()
penguins |>
  ggplot(aes(x = flipper_length_mm, y = sex, fill = sex)) +
  geom_violin()

# fit lines from geom_smooth()
my_plot <- penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point(size = 1.5, alpha = 0.7) +
  geom_smooth(method = 'lm', se = F)
my_plot

# facets -> split panels by value.
my_plot <- my_plot + facet_wrap(~island)
my_plot

# scales - set axis / color scales...
my_plot <- my_plot + rcartocolor::scale_color_carto_d(palette = 4)
my_plot

# labs
my_plot <- my_plot +
  labs(
    x = "Bill Length (mm)",
    y = "Bill Length (mm)",
    color = "Species",
    title = "Palmer-penguins",
    subtitle = "Bill measurements for penguins in the Palmer archipelago, Antarctica"
  )
my_plot

# preset themes
my_plot <- my_plot + theme_bw()
my_plot

# customizing theme ----

library(showtext) # functions for managing fonts...

# https://fonts.google.com/
font_add_google("Lobster")
font_add_google("IBM Plex Sans")
font_add_google("Roboto")

theme_lobster <- function(){
  theme(
    text = element_text(family = 'Roboto'),
    plot.title = element_text(family = 'Lobster', face = 'bold', size = 16),
    plot.subtitle = element_text(family = 'IBM Plex Sans', face = 'italic', size = 10),
    legend.position = 'bottom',
    axis.title = element_text(color = 'grey60', size = 9),
    axis.text = element_text(color = 'grey60', size = 7),
    legend.text = element_text(family = 'Lobster', size = 12),
    strip.background = element_rect(fill = 'grey95'),
    strip.text = element_text(family = 'Roboto', size = 12)
  )
}

my_plot + theme_lobster()





































## Solutions

# penguins |>
#   mutate(across(ends_with('_mm'), ~.x / 10)) |>
#   rename_with(~.x |> str_replace('_mm', '_cm'))
