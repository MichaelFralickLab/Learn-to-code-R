# regex demo
library(tidyverse)

fruits <- tibble(fruit)
fruits

# count letters
fruits |>
  mutate(chars = nchar(fruit)) |>
  filter(chars == 5)

# str count
fruits |>
  mutate(.a = str_count(fruit, 'a')) |>
  arrange(desc(.a))

# str.. detect, extract, split....


# start and end in a vowel
fruits |> filter(str_detect(fruit, '^')) |> print(n=20)

fruits |> filter(str_detect(fruit, 'e(a)?r')) |> print(n=20)

fruits |> filter(str_detect(fruit, '[aeiou]{2}')) |> print(n=20)


fruits |>

  mutate(
    # berry = str_locate(fruit, 'berry'),
    # first = word(fruit),
    Fruit = str_to_title(),

    has_D = str_detect('d')
  )

stringr::words |>

tibble(text = stringr::sentences) |>

  str_conv(fruit,"ISO-8859-1"

