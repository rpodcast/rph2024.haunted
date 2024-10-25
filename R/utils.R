import_prompt_file <- function() {
  prompt_content <- readLines("inst/docs/prompt.md", warn = FALSE)
  system_prompt_str <- paste(prompt_content, collapse = "\n")
  return(system_prompt_str)
}

count_words <- function(x) {
  words <- stringr::str_split(x, "\\s+")[[1]]
  word_count <- length(words)
  return(word_count)
}

#' process haunted data frame
#' 
#' @param n_records Number of records to retain for each state: Default is 4
#' 
#' @return duckplyr tibble of process haunted places data frame
#' @import duckplyr
process_haunted_data <- function() {
  haunted_df <- duckplyr_df_from_csv("inst/extdata/haunted_places.csv") |>
    mutate(n_words = count_words(description), .by = c(location)) |>
    arrange(state_abbrev, desc(n_words)) |>
    filter(!(is.na(city_latitude) & is.na(latitude))) |>
    slice_max(n_words, n = 4, by = state_abbrev)
}

#' Display quiz question
#' 
#' This function assembles the necessary information to display a quiz question and multiple choice answers
#' 
#' @param place_name String of the haunted place name
#' @param question_text String of the question text
#' @param correct_answer String with the correct answer to the quiz question
#' @param incorrect_choice_1 String with the first incorrect answer for the quic
#' @param incorrect_choice_2 String with the second incorrect answer for the quic
#' @param incorrect_choice_3 String with the third incorrect answer for the quic
#' 
#' @return a list with the following elements:
#' * place_name
#' * question_text
#' * correct_answer
#' * incorrect_choice_1
#' * incorrect_choice_2
#' * incorrect_choice_3
