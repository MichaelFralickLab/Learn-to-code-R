# p <- source('hello_world.R')

planets <- c('Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn')
planets

# greet this single planet
hello_planet <- function(planet) {
  paste("Hello", planet)
}

# applying hello_ function to all planets
greetings <- purrr::map_chr(
  .x = planets,
  .f = ~hello_planet(.x)
)

# pattern [data] -> map( data, function)
# function -> compose the steps to process a single dataset.

