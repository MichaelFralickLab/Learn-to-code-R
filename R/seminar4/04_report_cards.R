# Surprise! Mike has asked me to prepare an evaluation of your skills. I've prepared report cards for each of you!

#' `Run this script`, then try `report_card('your full name')` in the terminal to get your report

# install.packages(c('beepr', 'cowsay','emojifont','praise'))

require(beepr)
require(cowsay)
require(emojifont)
require(praise)
require(purrr)

report_card <- function(student_name) {
  celebration_beep <- function() {
    beepr::beep(10)
    Sys.sleep(0.15)
  }

  friendlies <- function(type = 'message', ...) {
    cowsay::say(
      type = type,
      what = paste(
        emojifont::emoji('trophy'),
        praise::praise(),
        emojifont::emoji('thumbsup')
      ),
      by = names(cowsay::animals) |> sample(1)
    )
  }

  tabulate_report_card <- function(student_number) {
    set.seed(student_number)
    tibble::tibble(
      subjects =
        crayon::bgGreen(crayon::bold(
          c(
            '\n\n R programming:                              \n',
            '\n\n Data handling:                              \n',
            '\n\n Data visualization:                         \n'
          )
        )),
      evaluations = purrr::map_chr(seq(3), ~ friendlies(type = 'string')),
    ) |>
      tidyr::pivot_longer(dplyr::everything()) |>
      dplyr::pull(value)
  }

  whats_my_student_number <- function(student_name) {
    tibble::tibble(
      x = student_name |>
        stringr::str_to_lower() |>
        stringr::str_remove_all('[^a-z]') |>
        stringr::str_split('') |>
        purrr::flatten_chr()
    ) |>
      dplyr::left_join(
        tibble::tibble(x = letters, value = seq_along(letters)),
        by = "x"
      ) |>
      dplyr::pull(value) |>
      sum() |>
      as.integer()
  }

  render_report_card <- function(student_name) {
    celebration_beep()
    student_number <-
      whats_my_student_number(student_name = student_name)
    report_card <-
      tabulate_report_card(student_number = student_number) |>
      suppressMessages()
    "\n\n--- Learn to Code R: Report Card for {stringr::str_to_title(student_name)} ---" |>
      stringr::str_glue() |>
      crayon::bgBlue() |>
      cat()
    report_card |>
      cat()
  }
  render_report_card(student_name)
}
