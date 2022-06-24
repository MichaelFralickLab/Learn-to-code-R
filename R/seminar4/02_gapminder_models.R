#' ---
#' title: Many models and a lot of plots | Gapminder dataset
#' desc:
#'   We'll have a look at the Gapminder data from Dr. Hans Rosling. Dr. Rosling is well-known for his data-driven work on global development. I recommend watching his talks (if you haven't already) to see how to do effective data communication.
# https://www.gapminder.org/
# https://www.youtube.com/watch?v=jbkSRLYSojo
#
#' ---

library(tidyverse)
library(tidylog, warn.conflicts = F)
library(gapminder)
library(ggiraph)
library(patchwork)
library(gganimate)
library(ggrepel)
ggplot2::theme_set(theme_classic())

# to assign in global env (look at env pane)
gapminder <- gapminder::gapminder |>
  mutate(country = str_remove_all(country, "'"))

gapminder |> glimpse()
gapminder |> glimpse()

#' `country` is the unit of observation;
#' `continent` is a grouping variable for `country`
#' `time` indicates the ordering of repeated measures on `country`
#' `lifeExp`, `pop`, `gdpPercap` are the demographics of interest

#' 60 years of data for each country
gapminder |>
  count(continent, country, sort = T) |>
  mutate(years = n * 5)

#' life exp timeseries: trends for each continent
plt_life_exp <-
  gapminder |>
  ggplot(aes(year, lifeExp)) +
  geom_path(aes(group = country), alpha = 0.12) +
  geom_smooth(method = 'loess', se = F) +
  facet_grid(~continent)

plt_life_exp



## Linear models for each country -----------------

# make 1 model
canada <- gapminder |>
  filter(country == 'Canada')

model <- lm(lifeExp ~ year, data = canada)
model |> summary()

## Make a function for any country ------

# function to subset one country and fit a linear model
gapminder_model <- function(data, country){
  country_data <- data |> filter(country == country)
  model <- lm(lifeExp ~ year, data = country_data)
  return(model)
}

gapminder_model(gapminder, 'China')
gapminder_model(gapminder, 'Taiwan')
gapminder_model(gapminder, 'Japan')

gapminder_model(gapminder, 'China') |> summary()

## Model all the countries at once  ------

library(broom)

gapminder |>
  group_by(continent, country) |>
  nest() |>
  mutate(
    model = purrr::map(data, ~lm(lifeExp ~ year, data = .)),
    tidy = purrr::map(model, ~broom::tidy(.))
  ) |>
  unnest(tidy) |>
  filter(term == 'year')




