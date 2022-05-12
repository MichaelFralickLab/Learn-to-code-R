# bard

# string operations and regular expressions
library(tidyverse)

bard <- bardr::all_works_df |>
  as_tibble() |>
  transmute(name, genre,
            content = content |>
              str_replace_all('\\u001a', "'") |>
              str_remove_all([:digits:]{})) |>
  group_by(name, genre) |>
  nest(data = content) |>
  ungroup()

bard |>
  select(name, data) |>
  unnest(data) |>
  slice_sample(n = 1000) |>
  view()

bard |>
  ggplot(aes(y = genre)) +
  geom_bar()

# hamlet
hamlet <- bard |>
  ungroup() |>
  filter(name == 'Hamlet') |>
  select(name, data) |>
  unnest(data)

hamlet |>  print(n = 100)

hamlet |>
  mutate(act = str_extract(content, '^ACT [MCXIVLD]+'),
         scene = str_extract(content, '^Scene [MCXIVLD]+ *.+'),
  ) |>
  filter(!is.na(act) | !is.na(scene))

