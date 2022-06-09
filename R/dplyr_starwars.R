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


# lets do a plot of the same data that we summarised
starwars |>
  ggplot(aes(mass, sex, color = sex)) +
  geom_boxplot(alpha = 0, outlier.color = NULL, color = 'gray') +
  geom_jitter(alpha = 0.6, shape = 1, show.legend = F) +
  scale_x_log10() +
  theme_classic()



















#-----------------------------------------------------

#' *super handy*
#' `count` tallies observations for each combination of (input variables)
starwars |> count(species, sex)

#' *pretty useful*

#' `relocate` columns to the left (- to the right)
#' helpful when you want to see the one you're working on
starwars |> relocate(starships)

#' `rename` columns: new_name = old_name
starwars |> rename(height_cm = height)

#' `slice_*` functions get a subset of rows (by various criteria)
starwars |> slice_sample(n = 5)

#'
starwars |> dplyr::




#-----------------------------------------------------








# with across
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




# using a prefix, pivoting, facetted plot from pair of variables
starwars |>
  select(name, where(is.numeric)) |>
  pivot_longer(-name, names_to = 'attribute') |>
  ggplot(aes(x = value)) +
  geom_histogram() +
  facet_wrap(facets = vars(attribute), scales = 'free_x', ncol = 1)




# we can use if_else to do something based on a condition

starwars |>
  mutate()


# iris |>
#   as_tibble() |>
#   filter(Sepal.Length > 5, Petal.Width < 2) |>
#   tidylog() |>
#   mutate(x = Sepal.Length*Sepal.Width) |>
#   tidylog()

starwars <- dplyr::starwars

species_lookup <- starwars |>
  count(species, sort = T) |>
  transmute(
    species,
    pooled_species = if_else(condition = (n == 1), 'Other', species)
  )

starwars |>
  left_join(species_lookup, by = "species") |>
  glimpse()




starwars |>
  select(name, starships) |>
  tidylog() |>
  unnest(cols = c(starships)) |>
  tidylog() |>
  ggplot(aes(y = name, x = starships)) +
  geom_point() +
  scale_x_discrete(position = 'top') +
  theme(axis.text.x.top = element_text(angle = 60, hjust = 0))


starwars |>
  left_join(species_lookup, by = "species") |>
  mutate(pooled_species = replace_na(pooled_species, 'Other')) |>
  filter(pooled_species %in% c('Human', 'Droid')) |>
  ggplot(aes(height, mass, color = pooled_species)) +
  geom_point(alpha = 0.5) +
  ggrepel::geom_text_repel(aes(label = name)) +
  geom_smooth(size = 0.5, span = 1.1) +
  scale_y_log10() +
  facet_wrap(~species, scales = 'free', ncol = 1) +
  theme(legend.position = 'none')

df <- starwars |>
  filter(species %in% c('Human', 'Droid')) |>
  select(species, height, mass, gender)

loe

library(broom)

model_rs <-
  tribble(
    ~formula, ~model,
    "mass ~ height", lm(formula = mass ~ height, data = df),
    "mass ~ height + species", lm(formula = mass ~ height + species, data = df),
    "mass ~ height + species*height", lm(formula = mass ~ height + species*height, data = df)
  ) |>
  mutate(tidy = map(model, tidy),
         glance = map(model, glance),
         augment = map(model, augment)
  )

model_rs |>
  select(formula, tidy) |>
  unnest(tidy) |>
  view()


lm(formula = mass ~ height, data = human_v_droid_sizes)

lm(formula = mass ~ height + species, data = human_v_droid_sizes) |> broom::tidy()
lm(formula = mass ~ height, data = human_v_droid_sizes) |> broom::tidy()
lm(formula = mass ~ height, data = human_v_droid_sizes) |> broom::glance()

lm(formula = mass ~ height + species + gender, data = human_v_droid_sizes) |> summary()

# starwars |> filter(is.na(species)) |> view()

