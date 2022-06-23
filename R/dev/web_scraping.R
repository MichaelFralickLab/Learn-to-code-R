library(tidyverse)
library(rvest)

wiki <- "https://en.wikipedia.org/wiki/List_of_Star_Wars_characters"

scrape_table <- function(table){
  table
}

starwars_tbls <- wiki |>
  rvest::read_html() |>
  rvest::html_nodes("table")  |>
  map(~ .x |>
        html_table(fill = TRUE, header = T) |>
        clean_names()) |>
  purrr::keep(
    ~names(.x) |>
      identical(c('name', 'portrayal', 'description'))
    ) |>
  enframe(name = 'table') |>
  mutate(right_names = map_lgl(
    value, ~names(.x) |> identical(c('name', 'portrayal', 'description')))
  ) |>
  filter(right_names) |>
  select(-right_names) |>
  unnest(cols = value) |>
  print()

dplyr::starwars |>  view()

starwars_tbls |>
  anti_join(dplyr::starwars) |>
  view()

dplyr::starwars |>
  left_join(starwars_tbls) |>
  view()



starwars_tbls <- wiki |>
  rvest::read_html() |>
  rvest::html_nodes("th") |>
  map(~.x |> rvest::html_nodes('tr')) |>
  # keep(~!is.null(.x)) |>
  print()

