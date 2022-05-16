# p <- source('hello_world.R')

planets <- c('Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn')
planets

# greet this planet
hello_planet <- function(planet) {
  paste("Hello", planet)
}

greetings <- purrr::map_chr(
  .x = planets,
  .f = ~hello_planet(.x)
)



# pattern [data] -> map( data, function)
# function -> compose the steps to process a single dataset.

