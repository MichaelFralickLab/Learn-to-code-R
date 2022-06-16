library(tidyverse)

tibble(
  x = seq(0, 1, by = .01),
  sigmoid = 1 / (1 + 0.5 * exp(-0.7 * (10 * x - 5)))
) |>
  ggplot(aes(x, sigmoid)) +
  geom_point(shape = 1) +
  labs(y = 'power', x = 'effort', title = 'R learning curve')

