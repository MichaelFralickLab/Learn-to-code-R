library(tidyverse)

get_bardle_list <- function(){
  bardr::all_works_df |>
    as_tibble() |>
    select(content) |>
    mutate(
      content = str_trim(content) |>
        str_to_lower() |>
        str_remove_all('[:punct:]|[:digit:]'),
      word = content |>
        str_extract_all('\\b[a-z]{5}\\b')
    ) |>
    unnest(word) |>
    distinct(word) |>
    mutate(word_split = str_split(word, '')) |>
    select(word, word_split)
}

get_solution <- function(word_list){
  word_list |>
    sample_n(1) |>
    unnest(word_split) |>
    select(word_split)
}

get_guess <- function(word_list) {
  cat("enter guess")
  # get input from terminal
  guess <- scan(
    what = character(length = 1L),
    n = 1,
    nlines = 1,
    strip.white = T,
    quiet = T
  )
  guess <- str_to_lower(guess)

  # recursively get input until word is valid
  if (!guess %in% word_list$word) {
    cat("Not in bard list, guess again.\n")
    return(get_guess(word_list))
  }
  return(guess |>
           str_split('') |>
           unlist() |>
           as_tibble() |>
           set_names('guess'))

}

get_comp <- function(guess, solution, ...){
  # compare guess and solution, add highlighting
  bind_cols(guess, solution) |>
    mutate(yellow = guess %in% solution$word_split,
           green = guess == word_split,
           guess = str_to_upper(guess),
           crayon = case_when(
             green ~ crayon::bgGreen(str_glue("{guess} ")),
             yellow ~ crayon::bgYellow(str_glue("{guess} ")),
             TRUE ~ crayon::bgBlack("_ ")
           )
    )
}

# glue the response together and display
get_comp_string <- function(comp){
  comp |>
    summarise(rs = paste0(crayon, collapse = '')) |>
    pull(rs)
}


## play game
bardle_list <- get_bardle_list()
solution <- get_solution(bardle_list)

get_blank <- function(){
    cat(crayon::bgBlack("\n_ _ _ _ _"))
}


for (x in 1:6) {
  # show empty on 0th guess
  if (x == 1) get_blank()

  guess <- get_guess(bardle_list)
  comp <- get_comp(guess, solution)
  cat(get_comp_string(comp))

  # detect win and break
  if (sum(comp$green) == 5) {
    cat(praise::praise())
    break
  }

  # show empty on 0th guess
  if (x == 6) {
    cat('\nTry again.\n', str_c(unlist(solution)))
    break
  }
}


## TODO show all guesses on the screen together
