# table operations

library(tidyverse)

# these are temperature data for two beavers with readings every ten mins
datasets::beaver1
datasets::beaver2

# this is a nicer wrapper
b1 <- datasets::beaver1 |> as_tibble()
b2 <- datasets::beaver2 |> as_tibble()

b1 |> glimpse()



b1 |>
  ggplot(aes(day, temp)) +
  geom_point() +
  geom_path()

b1 |> mutate(active = as.logical(activ)) |> summary()

b1 |>
  ggplot(aes(day, temp)) +
  geom_point(aes(color = as_factor(activ))) +
  geom_path()


# collect both beaver datasets
# make a list
beavers <- list(b1, b2)

beavers


beavers <- beavers |>
  purrr::imap(~.x |> mutate(beaver_id = .y)) |>
  bind_rows()

beavers |>
  mutate(
    active = as.logical(activ),
    # lets split 'time' into minutes and hours!
    min = str_extract(time, '..$') |> as.numeric(),
    # now how would you apply the same strategy for hours?
    hour = str_remove(time, '..$'),
    real_time = lubridate::hm(hour, min)
  )

# make a list but simplifies - we lose
map()
