#-------------------------------------------------------#
## Project: Learn to code - seminar 2
## Script: Starwars | dplyr and ggplot2
#-------------------------------------------------------#
#'
#'
#'
#'
#-------------------------------------------------------#
#  Rproject                                         ----
#-------------------------------------------------------#
#'
#' before we get going
#' _ Project workflow - create a new project _
#'
#'  - make `file paths` relative to the project root
#'  - set the `working directory` to the project root
#'  - pair excellently with `git` repos
#'  - saves project-specific `settings`
#'
#' Moreinfo:
#' https://www.tidyverse.org/blog/2017/12/workflow-vs-script/
#'
#'
#'
#-------------------------------------------------------#
#  Packages                                        ----
#-------------------------------------------------------#
#'
#' `tidyverse` has all our data handling functions
#' which come from multiple packages (`dplyr`, `ggplot2`, ..)
#' that are all loaded by tidyverse
#'
#' `tidylog` gives nice feedback (optional, recommended)
#' `skimr` gives a nice data summary
#' `here` lets us use file paths relative to project root.
#' `xlsx` to write to Excel

# (uncomment the next line to install packages)
# install.packages(c('tidyverse', 'tidylog', 'skimr', 'here', 'xlsx', 'ggbeeswarm', 'crayon', 'gt'))

library(tidyverse)
library(tidylog)
library(skimr)
library(here)
#'
#'
#'
#-------------------------------------------------------#
#  Data                                            ----
#-------------------------------------------------------#
#'
#' We'll be learning how to use the `dplyr` package to
#'  handle data tables today.
#' https://dplyr.tidyverse.org/index.html
#'
#' This `starwars` characters dataset should be fun and
#' familiar to you  (hopefully) but our focus is on the
#' `functions` that we'll use to manipulate data tables.
#'
#' _By the way, Yoda needs your help with some data analysis since he is a terrible programmer (can't learn the syntax) _
#'
#'
#' starwars dataset
starwars <- dplyr::starwars
#'
#'
#'
#-------------------------------------------------------#
#  Using the pipe                                    ----
#-------------------------------------------------------#
#'
#' *Chaining functions into pipelines*
#'
#' `data` (our tbl) is always the first argument
#' in dplyr functions: `f(data, ...)`
#'
#' We can use `|>` to chain our steps together easily like:
#'
#' `result <- data |> `
#'    `first(x = 1) |>`
#'    `second(y = 2) |>`
#'    `third(z = 3)`
#'
#' which is the same as, but easier to read than:
#'
#' `result <- third(second(first(data, x = 1), y = 2), z = 3)`
#'
#'
#'
#-------------------------------------------------------#
#  Look at the data                                  ----
#-------------------------------------------------------#
#'
#' *(these side effects don't change the data)*
#'

#' `glimpse` side-effect
starwars |> glimpse()

#' `view()` to pop the viewer screen open
starwars |> view()

#' `skim` gives a nice, quick summary of the data
starwars |> skimr::skim()





#-------------------------------------------------------#
# No Grogu? Stop everything ----
#-------------------------------------------------------#

# Test your data with code!


# eg. throw error if Grogu absent from data
if (!'Grogu' %in% starwars$name) stop("'Grogu' not found")


# here is the row we need to add for Grogu
grogu <-
  tibble(
    name = 'Grogu',
    height = 24,
    mass = 7.5,
    hair_color = 'blond',
    # baby yoda skin  https://colorswall.com/palette/85592
    skin_color = '#9cbb80',
    eye_color = 'brown',
    # wrap quotes like ' " ' or " ' "
    species = "Yoda's species",
    homeworld = NA,
    ) |>
  print()

# append Grogu to the starwars data
starwars <-
  starwars |>
  bind_rows(grogu) |>
  print()

# test now passes, yay!
if (!'Grogu' %in% starwars$name) stop("'Grogu' not found")

rm(grogu)






##------------------------------------------------#
# dplyr:  one-table functions                ----
##------------------------------------------------#
#'
#' `dplyr` is a nice domain specific language for handling tables
#'
#' These are the main toolkit
#' `select`
#' `filter`
#' `mutate`
#' `summarise`
#' `group_by`
#' `nest` and `unnest`
#'
#' With help from these to boost their power
#' `across`
#' `where`
#' `tidyselect helpers`
#'
#' Simple and handy things you'll love
#' `count`
#' `arrange`
#' `distinct`
#' `rename` and `rename_with`
#' `relocate`
#'
#' We'll look at these more advance ops next week
#'  `pivot_*`
#'  `join_*`
#'
#'
#'
#'
#'
#'
##------------------------------------------------#
## select                                       ----
##------------------------------------------------#
#'
#' `select` subsets specified columns by name
#'
starwars |> select(name, height, mass, sex)

#' You try: _subset columns ending with 'color'_




##------------------------------------------------#
## select helpers                               ----
##------------------------------------------------#
#' Imagine we have tons of column names with '_color'
#' We want to subset (or drop) all of them
#' Without writing all their names....
#' `tidyselect helpers` - let's go!
#' https://tidyselect.r-lib.org/reference/language.html




#' What about if we wanted to only keep certain datatypes?



#' We can subset by index, but just don't do that bc
#' *magic numbers* don't make it clear what the code does!

starwars |> select(1, 2, 3, 8)















##------------------------------------------------#
## filter                                      ----
##------------------------------------------------#
#'
#' `filter` keeps rows that pass a set of conditions
#' https://dplyr.tidyverse.org/reference/filter.html

#' _ Can you find the names of all the droids? _

starwars |> filter(species %in% 'Droid')



#' _ Subset the non-humans, count how many there are. _















##------------------------------------------------#
## count                                       ----
##------------------------------------------------#

#' `count` tallies observations by given variable(s)
starwars |> count(species, sort = T)



#' __which (species, homeworld) is most prevalent?__
starwars |> count(homeworld, species, sort = T)




##------------------------------------------------#
## arrange                                       ----
##------------------------------------------------#
#'
#' `arrange` can also sort a table
#'

starwars |>
  count(species) |>
  arrange(desc(n))


##------------------------------------------------#
## mutate                                       ----
##------------------------------------------------#
#'
#' *Transforming variables*
#'
#' `mutate` changes a column or creates a new one
#'

# create new variable 'weight_lb'
starwars |> mutate(weight_lb = 2.2 * mass)




#' __ create a variable called 'body_size' __
#' __ which is the product of mass and height __





##------------------------------------------------#
## summarise                                       ----
##------------------------------------------------#
#'
#' `summarise` is similar to `mutate` but for summary statistics
#' (where a vector is 'reduced' or 'aggregated' into a single value)
#'

starwars |>
  summarise(
    n = n(),
    height_mean = mean(height),
    height_sd = sd(height),
  )

# wth?









##------------------------------------------------#
## Dealing with NA                             ----
##------------------------------------------------#

# crayon for fancy colored terminal output for messages
cat(
  crayon::bgBlue(
    crayon::bold('\n\nInterlude / PSA:'),
    crayon::underline(
      '\nMissing values (NA) are contagious\n'
      )
    )
  )


#' this doesn't work, beacuse NA right?
1 + NA

# related problem: mean returns NA if any input value is NA!
mean(c(NA, 1:10))

# solution: explicitly ignore NAs with na.rm
mean(c(NA, 1:10), na.rm = T)



##------------------------------------------------#
## summarise with na.rm = T                    ----
##------------------------------------------------#

#' now we'll fix the problem with NAs
starwars |>
  summarise(
    n = n(),
    height_mean = mean(height, na.rm = T),
    height_sd = sd(height, na.rm = T),
    )



#' _ get the overall median, min, and max values for 'mass' _
























##------------------------------------------------#
## group_by / summarise                        ----
##------------------------------------------------#

#' `group_by` allows us to split data for groupwise-computation

starwars |>
  group_by(species) |>
  glimpse()

#' On it's own, `group_by` doesn't do much,
#' BUT it sets up our data for later steps
#' so we can do `summarise` and get results for each group!

starwars |>
  group_by(species) |>
  summarise(
    n = n(),
    height_mean = mean(height, na.rm = T),
    height_sd = sd(height, na.rm = T),
  )


#' _ 1: get the overall median, min, and max of 'mass' _







#' _ 2: compute median, min, and max of character masses for each sex _





















##------------------------------------------------#
## plots  with ggplot2             ----
##------------------------------------------------#

# barplot (one or two discrete vars)
starwars |>
  count(sex, homeworld) |>
  ggplot(aes(n, fct_rev(homeworld), fill = sex)) +
  geom_col() +
  labs(y = NULL, title = 'Starwars character homeworlds')

# scatter (two continuous + shape, color, size, alpha)
starwars |>
  mutate(is_human = species %in% 'Human') |>
  filter(is_human) |>
  ggplot(aes(mass, height,
             color = birth_year,
  )) +
  geom_point(alpha = 0.75) +
  ggrepel::geom_text_repel(aes(label = name),
                           size = 4, alpha = 0.85) +
  scale_color_viridis_c(option = 'C', end = 0.9) +
  theme_bw()

# add trendline with geom_smooth, use color for groups
starwars |>
  mutate(is_human = species %in% 'Human') |>
  ggplot(aes(birth_year, height,
             color = is_human,
             fill = is_human,
             )) +
  geom_point(alpha = 0.75) +
  geom_smooth(alpha  = 0.25) +
  scale_x_log10() +
  theme_bw()


# sometimes we have want separate panels
starwars |>
  mutate(is_human = species %in% 'Human') |>
  ggplot(aes(birth_year, height,
             color = is_human,
             fill = is_human,
  )) +
  geom_point(alpha = 0.75) +
  geom_smooth(alpha  = 0.25) +
  facet_wrap(~is_human, scales = 'free_y', nrow = 2) +
  scale_x_log10() +
  theme_bw()


# lets do a plot of the same data that we summarised
# masses ~ sex
starwars |>
  ggplot(aes(
    x = mass,
    y = sex,
    color = sex,
    fill = sex
  )) +
  # geom_jitter(alpha = 0.4, show.legend = F) +
  # geom_boxplot(alpha = 0, show.legend = F,
  #              outlier.color = NULL, color = 'gray') +
  # geom_violin(
  #   alpha = 0, color = 'grey', fill = 'grey',
  #   draw_quantiles = c(0.25, 0.5, 0.75)
  # ) +
  # ggbeeswarm::geom_beeswarm(
  #   groupOnX = F,
  #   alpha = 0.8, shape = 1, size = 0.8
  # ) +
  scale_x_log10() +
  theme_classic()


#' learn more about ggplot2 here:
#' https://ggplot2.tidyverse.org/

#' save the cheatsheet and try out different plots
#' https://github.com/rstudio/cheatsheets/blob/main/data-visualization-2.1.pdf




diamonds |>
  ggplot(aes(carat, price, color = cut)) +
  geom_point(alpha = 0.21, size = 0.21) +
  scale_color_viridis_d() +
  guides(color=guide_legend(override.aes = list(size = 5))) +
  theme_light()





##----------------------------------------------##
#' *reading and writing files* with `read_*` and `write_*`
##----------------------------------------------##

# create a starwars folder that we save files to
# we can pipe the 'output' suppressWarnings
dir.create('starwars')  |> suppressWarnings()


## Comma-separated values (csv) ---------

# write a csv file (flattens lists)
starwars |> readr::write_csv('starwars/starwars.csv')

# read csv file
read_csv('starwars/starwars.csv')



## R data series files (rds) ---------

# write rds binary files (keeps data types & nested data)
starwars |>
  readr::write_rds('starwars/starwars.rds', compress = 'gz')

# read an rds binary
read_rds('starwars/starwars.rds')

# excel files require two packages
# can't take nested data  (drop any list columns),
# but keeps data types

starwars |>
  select(-where(is.list)) |>
  xlsx::write.xlsx(file = 'starwars/starwars.xlsx')

readxl::read_excel('starwars/starwars.xlsx')











#----------------------------------------------------

#' What if we want to *match a pattern* in text data?
#' Use `str_*` functions from `stringr`
#'
#' Patterns are regular expressions, *regex*
#' Here, ` ^ `` indicates the start of the string
#' [A-Za-z]+ matches any block of letters

str_detect('Darth Vader', '^Darth [A-Za-z]+')
str_detect('Master Darth Vader', '^Darth [A-Za-z]+')


# find all dudes with the first name 'Darth'
# test for the pattern 'Darth <something>'
darths <-
  starwars |>
  filter(str_detect(name, '^Darth [A-Za-z]+')) |>
  select(name) |>
  print()

# rename to garth and lowercase their names
garths <-
  darths |>
  mutate(name = name |>
           str_replace_all('D', 'G') |>
           str_to_lower()
  ) |>
  print()

rm(darths, garths)

#' learn more about `stringr` and *regex* here
#' https://stringr.tidyverse.org/articles/regular-expressions.html

# super common uses - find emails, phone #, dates...
string <- "123-456-9876, 11 Foobar St., baz-1@gmail.com"
email_regex <- '[A-z0-9_-]+@[A-z0-9]+\\...(.)?'
phone_regex <- '[:digit:]{3}.[:digit:]{3}.[:digit:]{4}'

# extract text matching the pattern for email
str_extract(string = string,
            pattern = email_regex)

# replace text matching the pattern for phone
str_replace(string = string,
            pattern = phone_regex,
            replacement = '<phone number suppressed>')



rm(email_regex, phone_regex, string)








#----------------------------------------------------

#' *string interpolation* with `str_glue` and {}

# some data generated by our code
value <- rnorm(mean = 95, sd = 1, n = 1) |> round(1)

# insert result into a text template
str_glue(
  'String interpolation is a handy tool that I use in {value}% of my reports.')


rm(value)














#-----------------------------------------------------

#' *super handy*

#' `distinct` get unique combination of (input variables)
starwars |> distinct(species, sex)

#' stack tables with `bind_rows`
#' remove duplicates with `distinct`

# eg. duplicate data; remove any duplicates (cancels out)
bind_rows(starwars, starwars) |> distinct()

# nest / unnest lists
# open nested data up over more rows/cols
# fold up data into nested lists / tibbles

# eg. list the cast of each film in a nested column
films <-
  starwars |>
  select(name, films) |>
  unnest(films) |>
  nest(cast = name) |>
  print()

# which ships are flown by the most characters?
ships <-
  starwars |>
  select(name, starships) |>
  unnest(cols = c(starships)) |>  # keep_empty = T
  group_nest(starships, .key = 'pilots') |>
  mutate(piloted_by = map_dbl(pilots, ~nrow(.x))) |>
  arrange(desc(piloted_by)) |>
  print()

# join data
ships_births <-
  starwars |>
  select(name, birth_year) |>
  right_join(ships |> unnest(pilots), by = 'name') |>
  relocate(name, starships)

ships_births |>
  ggplot(aes(birth_year, starships)) +
  geom_point(alpha = 0.7)







##----------------------------------------------##

#' `across` allows us to repeat a mutate/summarise
#' on multiple columns

# modify all character strings to be uppercase
starwars |>
  mutate(
    across(
      .cols = where(is.character), # do all these cols
      .fns = ~str_to_upper(.x)     # with this function
      )
    )

# convert cols matching name pattern to factors
starwars <- starwars |>
  mutate(
    across(matches('color|sex|gend|home|spec'),
           as_factor
    ))

starwars |>
  select(-where(is.list)) |>
  base::summary()



## Let's Make a Summary Table


cohort <-
  starwars |>
  group_by(species) |>
  mutate(n = n()) |>
  filter(n > 2, !is.na(species)) |>
  glimpse()

cohort |> count(species)

# use *across* to compute a numeric summary for any numeric variables for the table 1.

tbl1 <-
  cohort |>
  summarise(
    across(
      .cols = where(is.numeric),
      .fns = list(
        'mean' = ~mean(.x, na.rm = T) |> round(),
        'sd' = ~sd(.x, na.rm = T) |> round()
      ),
      .names = "{.col}_{.fn}",
    ),
    N = n() |> as.character(),
    ) |>
  transmute(
    species,
    N,
    Height = str_glue('{height_mean} ± {height_sd}'),
    Mass = str_glue('{mass_mean} ± {mass_sd}'),
    ) |>
  print()


library(gt)

tbl1 |>
  # transpose data with pivots s.t. species are columns
  pivot_longer(-species) |>
  pivot_wider(names_from = species, values_from = value) |>
  # present as html table
  gt::gt(rowname_col = 'name') |>
  gt::tab_spanner('Species', c(Droid, Gungan, Human)) |>
  gt::tab_header(title = 'Table 1. Starwars cohort')







##----------------------------------------------##
#' *other, pretty useful, dplyr functions*
##----------------------------------------------##

#' `relocate` columns to the left (- to the right)
#' helpful when you want to see the one you're working on
starwars |> relocate(starships)

#' `rename` columns: new_name = old_name
starwars |> rename(height_cm = height)
starwars |> rename_with(~str_remove(.x, '_color'))

#' `slice_*` functions get a subset of rows (by various criteria)
starwars |> slice_min(birth_year) |> glimpse()
starwars |> slice_max(birth_year) |> glimpse()

#' eg. get a random sample of observations
starwars |> slice_sample(n = 5)


