#' ---
#' title:
#'   Ottawa Neighborhood Study - Covid cases - Heatmap
#' description:
#'   Getting and cleaning data is the first step to any analysis. Here we'll prepare a real dataset with a number of common issues. We'll create a heat map to visualize.
#' ---

# install.packages(c('tidyverse', 'janitor', 'lubridate', 'ggiraph'))

library(tidyverse)
library(janitor)
library(lubridate)
library(ggiraph)


## Heatmap --------------------------------

# My function is ready to make a heatmap of case rates...
# but it won't work until the data is organized properly!

ons_heatmap <- function(tidy_ons_data) {
  heatmap <-
    tidy_ons_data |>
    ggplot(aes(
      date,
      fct_rev(neighbourhood),
      fill = rate,
      label = neighbourhood,
      tooltip = neighbourhood,
    )) +
    scale_fill_viridis_c(direction = -1, option = 'C')  +
    geom_tile_interactive(width = 31) +
    labs(
      x = NULL,
      y = NULL,
      title = "Ottawa COVID case rates by hood",
      fill = 'Cases / 100k'
    ) +
    theme(axis.text.y = element_text(size = 6.5))

  ggiraph::girafe(ggobj = heatmap)
}

## Lookup table ---------------------------

# This help convert dates later on
months_lookup <- function(){
  str_to_lower(month.name) |>
  tibble::enframe(name = 'month_val', value = 'month')
}




## clean the data -------------------------

# I have COVID rates from this Ottawa
# Neighbourhoods Study that I want to analyze but
# it's not well organized for the heat map!

ons_data <- "https://www.arcgis.com/sharing/rest/content/items/7cf545f26fb14b3f972116241e073ada/data"

raw_data <- ons_data |> read_csv()
# metadata:
# _excluding_cases_linked_to_outbreaks_in_ltch_rh
# rate _per_100_000_population_


# I want to have three columns:
# * neighborhood
# * date
# * rate

tidy_data <-
  raw_data |>
  janitor::clean_names() |>
  rename_with(~.x |>
                str_remove(pattern = '_excluding_.*?_rh$') |>
                str_remove('per_100_000_population_in_')) |>
  select(-contains('number_of_cases_'),
         -contains('population_estimate'),
         -ons_id) |>
  select(-matches('cumul')) |>
  pivot_longer(contains('rate'),
               names_to = 'date',
               values_to = 'rate') |>
  mutate(
    date = str_remove(date, '^rate_'),
    year = parse_number(date),
    month = str_extract(date, '[a-z]+')
  ) |>
  left_join(by = 'month', y = months_lookup()) |>
  mutate(date = str_glue('{year}-{month_val}-15') |>
           lubridate::as_date()) |>
  transmute(
    neighbourhood = ons_neighbourhood_name,
    date,
    rate
) |>
  mutate(
    rate = case_when(
      rate == 'Suppressed' ~ '0',
      TRUE ~ rate
    ) |>
      as.numeric()
  )
  print()

## YYYY-MM-DD - ISO 8601 int'l std.


  ons_heatmap(tidy_ons_data = tidy_data)

  ons_heatmap(tidy_ons_data = tidy_data |> filter(neighbourhood> 'm'))

## make the heatmap ----------------------









## ----------------------------------


