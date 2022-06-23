#' ------------------------------------
#' *Modelling life expectancy over time from Gapminder data*

#' We'll perform an analysis using linear models, while also learning how to use functional programming to write minimal code. I'll show you handy packages for handling basic linear models.

# Load these ---------------------------
#
# install.packages(c('modelr', 'broom', 'gapminder'))
library(tidyverse, warn.conflicts = F)
library(tidylog, warn.conflicts = F)
library(modelr)
library(broom)
library(gapminder)
ggplot2::theme_set(theme_minimal())

## Plots -------------------------------

# plot linear model and data
# - you can set default inputs for your functions with =
# - within functions, we use {{}} to embrace the input data variable names
# (for tidyverse)

plot_gapminder <- function(data,
                           color = NULL,
                           alpha = 0.1){
  data |>
    ggplot(aes(year, lifeExp)) +
    geom_path(
      aes(color = {{color}}),
      alpha = alpha
    ) +
    geom_smooth(
      aes(color = {{color}}),
      method = 'lm',
      formula = 'y ~ x',
      alpha = 0
    ) +
    labs(
      subtitle =
        'Gapminder: life expectancy ~ year',
      color = enquo(color),
      x = NULL,
      y = 'Life expectancy'
    )
}

## Gapminder data ------------------------

gapminder <-
  gapminder::gapminder |>
  select(-pop, -gdpPercap)

gapminder |> glimpse()
gapminder |> plot_gapminder(alpha = 0.1)
gapminder |> plot_gapminder(color = continent, alpha = 0.1)

gapminder |> plot_gapminder(
  color = country == 'Canada',
  alpha = 0.1
  )

# remember to play it 'safe' with colors
gapminder |>
  plot_gapminder(color = continent,
                 alpha = 0.1) +
  rcartocolor::scale_color_carto_d(
    palette = 'Safe'
    )
  # coord_polar()


## Model 1: Canada ------------------------

# we want to model life expectancy over time for Canada



## Model 2: Rwanda ------------------------

# we want to model life expectancy over time for Rwanda



## Encapsulate modelling process ----------

# fun...


## Model every country --------------------

# We want to obtain the regression coefficients (slopes) from linear models for each country.


















