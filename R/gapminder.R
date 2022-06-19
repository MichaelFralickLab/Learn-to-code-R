#' ---
#' title: Many models and a lot of plots | Gapminder dataset
#' desc:
#'   We'll have a look at the Gapminder data from Dr. Hans Rosling. Dr. Rosling is well-known for his data-driven work on global development. I recommend watching his talks, if you haven't already, to how to do effective data presentations and communication.
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

## lifeExp vs gdp: all years
gapminder |>
  ggplot(aes(gdpPercap, lifeExp, color  = continent, size = pop)) +
  geom_point(alpha = 0.5) +
  geom_path(aes(group = country), size = 0.2, alpha = 0.3) +
  scale_x_log10()

# lifeExp vs gdp trajectories between 1952-2007
gapminder |>
  filter(year %in% c(min(year), max(year))) |>
  ggplot(aes(gdpPercap, lifeExp,
             shape = as_factor(year),
             color  = continent, size = pop)) +
  geom_point(alpha = 0.5) +
  geom_path(aes(group = country), size = 0.5, alpha = 0.6) +
  scale_x_log10()






## interactive plot --------------------------------------------------------

# use a function to make similar plots with a different variable
demographic_timeseries <- function(data, demographic){
  data |>
    ggplot(aes(year, {{demographic}},  label = country)) +
    geom_line_interactive(
      aes(group = country, data_id = country,
          tooltip = country, hover_css = "fill:none;"),
      color = 'darkgray',
      alpha = 0.3
    ) +
    geom_smooth(data, mapping = aes(year, {{demographic}}, group = NULL),
    method = 'loess', se = F) +
    facet_grid(~continent) +
    labs(x = NULL) +
    theme(axis.text.x = element_text(size = 5))
}

# call our function on each variable to make plots
plots <- list(
  pop = gapminder |> demographic_timeseries(pop) + scale_y_log10(),
  gpd = gapminder |> demographic_timeseries(gdpPercap) + scale_y_log10(),
  lifexp = gapminder |> demographic_timeseries(lifeExp)
)

# combine plots into three-part panel
demo_panel <- patchwork::wrap_plots(plots, ncol = 1)

# render plots as interactive html widget
ggiraph::ggiraph(ggobj = demo_panel, height = 5, width = 1)





## Animated plots ---------------------------------------------------------

# make an plot will all time points...
p <- gapminder |>
  ggplot(aes(gdpPercap, lifeExp, color = continent, size = pop)) +
  geom_point(alpha = 0.5) +
  ggrepel::geom_text_repel(
    data = gapminder |> filter(pop > 2*10**6),
    aes(label = country),
    max.iter = 100,
    max.overlaps = 250) +
  scale_x_log10()

# specify `year` as the variable that changes between frames
# add a title so we can see the year for each frame
animated <- p +
  transition_states(year,
                    transition_length = 2,
                    state_length = 1) +
  ggtitle('Gapminder data: {closest_state}') +
  enter_fade() +
  exit_shrink()

# show animation in viewer
animated

# save as a gif
anim_save('gapminder.gif', animation = animated)
















