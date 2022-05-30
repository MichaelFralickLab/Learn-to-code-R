#' ---
#' EXCEL PIZZA
#' ---
#' Your friend has been culturing a fast growing
#' microorganism cultured from an ice core. They have been storing each set
#' of observations in new column in an Excel file.
#' Recall, that excel has column numbering with letters... A = 1; AA = 27.
#' You ask how long has the experiment been running
#' He replies: 'We're up to column PIZZA!'
#' How many minutes has the experiment been running?
#'
#' NB
#' Each letter represents a number of columns based on the character and
#' position.
#' Counting is in base-26, thus:
#'
#'     letter_value  = (26 ^ position_exponent) * letter_to_number
#'
#' Where letter_to_number is from the letter (A=1) and position_exponent is 0 for the first position and then +1 for each position to the left.

#' Eg. KZ -> K.2 + Z.1
#' The letter K (number: 11) in 'KZ' is 2nd from right (exponent: 1)
#' so this K would contribute (26^1) * 11 = 286 to the number of columns in KZ
#'
# Z.1 is (26 ** 0) * .
#' So KZ is 286 + 26 = 312
#'
#' To get to the total for PIZZA we'd add all the column values
#'  (P.5) + (I.4) + (Z.3) + (Z.2) + (A.1)

library(tidyverse)

# built in data
base::LETTERS

# lower
str_to_lower(LETTERS)

# caps
str_to_upper(letters)

# str_which gets the index of the first matching value
str_which('A', LETTERS)
str_which('Z', LETTERS)


# lets create a function that makes it obvious what we are doing
letter_to_number <- function(x) str_which(x, LETTERS)
letter_to_number(letters)

# we can use a lookup table
alpha <- tibble(
  letter = LETTERS,
  number = 1:26
)


# concatenate / split
LETTERS
alpha <- str_c(LETTERS, collapse = '')
alpha
str_split(string = alpha, pattern = '') |> unlist()



input <- 'pizza'

input |>
  # capitalize and split the input
  str_to_upper() |>
  str_split('', ) |>
  # pluck(1) |>
  # put into a tbl
  tibble() |>
  set_names('letters') |>
  unnest(letters) |>
  # convert to a number; we need a map
  mutate(number = map_dbl(letters, ~str_which(.x, LETTERS))) |>
  # mutate(number = map_dbl(letters, ~letter_to_number(.x))) |>
  # do a reverse so that we get the right positions
  arrange(-row_number()) |>
  # compute the letter values
  mutate(exponent = row_number() - 1,
         letter_value = (26**exponent)*number
  ) |>
  summarise(solution = sum(letter_value))




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
      position = row_number(),
      exponent = position - 1,
    ) |>
    arrange(-position) |>
    select(-target, -position) |>
    mutate(columns = 26**(exponent * number)) |>
    arrange(-exponent)

  # add up each position
  value <- parsed_data |>
    summarise(col_number = sum(columns)) |>
    pull(col_number)

  # tell the user what column name was converted
  names(value) <- parsed_input
  return(value)
}

excel_col_to_number(target = 'KZ')


# Ok so when you design software, are you going to number the columns with the alphabet in some ridiculous fashion with a made up counting system, or just like regular nice-to-work with numbers?

# Lets' lean into the Excel way of doing things and include all ASCII characters as well as enough emoji to make the base for the counting system truly awful like 371. Is 371 prime? Perfect.

