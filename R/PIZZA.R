# excel has column numbering with letters (base-26)...
# how can we figure out which number the column is quickly and efficiently?

# I want to know how many columns does and excel sheet need to have the column:
# 'PIZZA'

library(tidyverse)

base::LETTERS
class(LETTERS)
length(LETTERS)

# lookup index
which(LETTERS == 'A')

alphabet <- str_c(LETTERS, collapse = '')
str_split(string = alphabet, pattern = '') |> unlist()

# that won't work for an infinitely-large excel file!
# we would need an infinitely large index to lookup values.




excel_col_to_number <- function(target, strict = F){

  # validate user input, return an error message if failure
  if (strict & str_detect(target, '[^A-Za-z]')) {
    stop('No non-letters allowed; strict-mode is enabled')
  }

  if (target == '') {
    stop('Invalid input: Empty string')
  }
  # extract only letters, capitalize.
  parsed_input <- target |>
    str_extract_all('[:alpha:]', simplify = T) |>
    str_c(collapse = '') |>
    str_to_upper()

  # compute the number of columns indicated by each letter.
  parsed_data <-
    tibble(target = parsed_input) |>
    mutate(characters = str_split(target, pattern = '')) |>
    unnest(characters) |>
    mutate(
      number = map_dbl(characters, ~which(base::LETTERS == .x)),
      position = row_number()
    ) |>
    arrange(-position) |>
    select(-target, -position) |>
    mutate(
      exponent = row_number() - 1,
      columns = 26**exponent*number
    ) |>
    arrange(-exponent)

  # add up each position
  value <- parsed_data |>
    summarise(col_number = sum(columns)) |>
    pull(col_number)

  # tell the user what column name was converted
  names(value) <- parsed_input
  return(value)
}

excel_col_to_number(target = 'pizza')


#
# 'teststring 12345678890 !@#$%^&*()_+-=[]{};:,./<>?' |>
#   str_detect('[:digit:]|[:punct:]|[:control:]|[:blank:]')
#
#   str_extract_all('[:alpha:]', simplify = T) |>
#   str_c(collapse = '')

#
number_to_excel_column  <- function(){}


# now do a list of terms

tibble(
  targets = c('pizza', 'cats', 'beer', ''),
  excel_col = map_dbl(targets, excel_col_to_number))

