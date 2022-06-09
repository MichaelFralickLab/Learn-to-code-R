##################################################
## Project: Learn to code - seminar 2
## Script: Starwars | dplyr and ggplot2
#'
#' We'll be learning how to use the `dplyr` package to handle data
#' tables today.
#' https://dplyr.tidyverse.org/index.html
#'
#' This `starwars` characters dataset should be *fun* and *familiar*  (hopefully) but try to focus on the `functions` used to manipulate the data
#'
##################################################

# load tidyverse packages
library(tidyverse)

# load tidylog to print out handy messages
library(tidylog)

# lets use this starwars data built into the dplyr package
starwars <- dplyr::starwars

#' use `glimpse` to see a compact representation of the data
glimpse(starwars)

















##----------------------------------------------##
#' *reading and writing files* with `read_*` and `write_*`
##----------------------------------------------##

# creates a 'starwars' directory that we'll save files to..
dir.create('starwars')  #|> suppressWarnings()

# write a csv file
starwars |> readr::write_csv('starwars/starwars.csv')

# read csv file
read_csv('starwars/starwars.csv')

# write rds files (keeps data types & nested data)
starwars |> readr::write_rds('starwars/starwars.rds', compress = 'gz')

# read rds
read_rds('starwars/starwars.rds')

# excel files (if you must)
xlsx::write.xlsx(
  starwars |> select(-where(is.list)), # to drop any list columns
  file = 'starwars/starwars.xlsx')

readxl::read_excel('starwars/starwars.xlsx')


















##------------------------------------------------##
#' `dplyr` for handling tables                  ----
#-----------------------------------------------------

#' we'll look at these *one-table functions* first:
#' `select` | `filter` | `mutate` | `summarise` | `group_by`

#-----------------------------------------------------
























#-----------------------------------------------------

#' `select` gets columns by name

starwars |> select(name, height, mass, sex)



#' now you try: _subset all the columns ending with 'color'_



#' imagine we have tons of columns that end in '_color' and we want to subset all of them, or drop all of them... (using tidyselect helpers)
























#----------------------------------------------------

#' `filter` keeps rows that pass a set of conditions

starwars |> filter(species == 'Droid')


#' try: _subset all the non-human characters_































#----------------------------------------------------
#' *Chaining*
#' because `data` (our tbl) is always the first argument in dplyr functions
#' we can use `|>` to chain our steps together easily

droids <-
  starwars |>
  filter(species == 'Droid') |>
  select(name, height, mass, gender, films) |>
  glimpse()



#' try: _ join the expressions you wrote with the |> pipe _


























#----------------------------------------------------

# mutate changes a column or creates a new one

starwars |> mutate(weight_lb = 2.2 * mass)

#' __ create a variable called 'body_size', which is the product of (multiply) mass and height __





























#----------------------------------------------------

#' `summarise` is similar to `mutate` but for summary statistics
#'  (where a vector is 'reduced' or 'aggregated' into a single value)

starwars |>
  summarise(
    n = n(),
    height_mean = mean(height, na.rm = T),
    height_sd = sd(height, na.rm = T),
    )

#' _find the overall median, min, and max values for characters' masses_























#----------------------------------------------------

#' `group_by` allows us to split data for groupwise-computation

starwars |>
  group_by(species) |>
  glimpse()

#' On it's own, `group_by` doesn't do much,
#' BUT it *sets up our data for later steps*
#' e.g. we can do `summarise` and we now *get results for each group*!

starwars |>
  group_by(species) |>
  summarise(
    n = n(),
    height_mean = mean(height, na.rm = T),
    height_sd = sd(height, na.rm = T),
  ) |>

#' use `arrange` to sort rows based on keys here




#' _ compute the med, min, max masses for each sex _





















#-----------------------------------------------------


# lets do a plot of the same data that we summarised earlier
starwars |>
  ggplot(aes(mass, sex, color = sex)) +
  geom_boxplot(alpha = 0, outlier.color = NULL, color = 'gray') +
  # geom_jitter(alpha = 0.6, shape = 1, show.legend = F) +
  scale_x_log10() +
  theme_classic()



















#-----------------------------------------------------

#' *super handy*

#' `distinct` get unique combination of (input variables)
starwars |> distinct(species, sex)

# remove any duplicates in data
bind_rows(starwars, starwars) |> distinct()

#' `count` tallies observations for each combination of (input variables)
starwars |> count(species, sex, sort = T)


#' *pretty useful*

#' `relocate` columns to the left (- to the right)
#' helpful when you want to see the one you're working on
starwars |> relocate(starships)

#' `rename` columns: new_name = old_name
starwars |> rename(height_cm = height)

#' `slice_*` functions get a subset of rows (by various criteria)
starwars |> slice_min(birth_year) |> glimpse()
starwars |> slice_max(birth_year) |> glimpse()

#' eg. get a random sample of observations
starwars |> slice_sample(n = 5)






#-----------------------------------------------------

#' *Run a simulation*
#'
#' *claim*: on average, only 63.2% of observations are represented in each bootstrap resample

# this draws a bootstrap resample of equal size with replacement
starwars |> slice_sample(n = nrow(starwars), replace = T)


# write a function to draw a resampled dataset (from any tbl)
draw_bootstrap <- function(data){
  data |> dplyr::slice_sample(n = nrow(data), replace = T)
}

# write a function to get % observations represented
analyse_bootstrap <- function(data){
  uniques <- data |> dplyr::distinct() |> nrow() / nrow(data)
  return(uniques)
}

# run our simulation 1000 times
B <- 1000

# create original sample dataset
data <- tibble(x = seq(B))

resamples <-
  tibble::tibble(
    resample_id = seq(B),
    boot = map(resample_id, ~draw_bootstrap(data)),
  ) |>
  mutate(
    prop_obs = map_dbl(boot, ~analyse_bootstrap(.x)),
  )

# summarise result
rs_data <-
  resamples |>
  summarise(point_est = mean(prop_obs),
            lower = quantile(prop_obs, p = 0.025),
            upper = quantile(prop_obs, p = 0.975))

# visualize distribution of results
resamples |>
  ggplot(aes(prop_obs)) +
  geom_histogram() +
  geom_vline(data = rs_data, aes(xintercept = point_est)) +
  geom_vline(data = rs_data, aes(xintercept = lower), lty = 2) +
  geom_vline(data = rs_data, aes(xintercept = upper), lty = 2)


















#' `across` allows us to repeat a mutate or summarise op on multiple columns

# with across to compute a numeric summary for any numeric variables
starwars |>
  group_by(species) |>
  summarise(across(
    .cols = where(is.numeric),
    .fns = list('mean' = mean, 'median' = median),
    .names = "{.col}_{.fn}",
    na.rm = T
    )) |>
  pivot_longer(-species) |>
  mutate(
    attribute = str_extract(name, '^[^_]+'),
    stat = str_extract(name, '[^_]+$')
    )


