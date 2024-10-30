import_prompt_file <- function() {
  prompt_content <- readLines(
    system.file("docs", "prompt.md", package = "rph2024.haunted"),
    warn = FALSE
  )
  system_prompt_str <- paste(prompt_content, collapse = "\n")
  return(system_prompt_str)
}

random_name <- function() {
  name_list <- readLines(
    system.file("docs", "random_names.txt", package = "rph2024.haunted"),
    warn = FALSE
  )
  sample(name_list, 1)
}

convert_name <- function(x) {
  tolower(x) |> stringr::str_replace_all("\\s+", "-")
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
  # define vector of icon types
  map_icon_choices <- c("castle", "dracula", "ghost_face", "ghost", "pumpkin", "skeleton", "witch_hat", "zombie_hand")
  #haunted_df <- duckplyr_df_from_csv("inst/extdata/haunted_places.csv")
  haunted_df <- duckplyr_df_from_csv(
    system.file("extdata", "haunted_places.csv", package = "rph2024.haunted")
  ) |>
    mutate(n_words = count_words(description), .by = c(state_abbrev, city, location, description)) |>
    arrange(state_abbrev, city, desc(n_words)) |>
    filter(!(is.na(city_latitude) & is.na(latitude))) |>
    slice_max(n_words, n = 1, by = c(state_abbrev, city)) |>
    mutate(
      latitude = ifelse(is.na(latitude), city_latitude, latitude),
      longitude = ifelse(is.na(longitude), city_longitude, longitude)
    ) |>
    filter(n_words >= 100) |>
    slice_max(n_words, n = 5, by = state_abbrev) |>
    mutate(city = stringr::str_remove_all(city, "\n")) |>
    mutate(icon_type = sample(map_icon_choices, 1), .by = location)
}

#' Import quiz question from JSON input
#' 
#' @param txt String of the quiz question in JSON format
#' 
#' @return a list with the following elements:
#' * place_name
#' * question_text
#' * correct_answer
#' * incorrect_choice_1
#' * incorrect_choice_2
#' * incorrect_choice_3
import_quiz_question <- function(txt) {
  # sanitize text since it is coming back as a markdown code snippet
  txt <- stringr::str_remove_all(txt, "```json")
  txt <- stringr::str_remove_all(txt, "``")
  jsonlite::fromJSON(txt = txt)
}

#' Prepare user prompt 
#' 
#' @param location name of haunted place
#' @param latitude haunted place latitude number
#' @param longitude haunted place longitude number
#' @param state string of state (full name) where haunted place is located
#' @param description string with description of haunted place
#' 
#' @return string with user prompt to send to chat bot
prepare_user_prompt <- function(location, latitude, longitude, state, description) {
  glue::glue("Please create a fun quiz question using {location} located at latitude {latitude}, longitude {longitude}, in the state of {state}. Here is a description of the place: {description}")
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
display_quiz_question <- function(place_name, question_text, correct_answer, incorrect_choice_1, incorrect_choice_2, incorrect_choice_3) {
  return(
    list(
      place_name = place_name,
      question_text = question_text,
      correct_answer = correct_answer,
      incorrect_choice_1 = incorrect_choice_1,
      incorrect_choice_2 = incorrect_choice_2,
      incorrect_choice_3 = incorrect_choice_3
    )
  )
}

create_board <- function(user_name) {
  if (golem::app_prod()) {
    board <- pins::board_s3(
      bucket = get_golem_config("pin_board_root_name"),
      prefix = user_name
    )
  } else {
    board_path <- file.path(get_golem_config("pin_board_root_folder"), get_golem_config("pin_board_root_name"), user_name)
    if (!dir.exists(board_path)) dir.create(board_path, recursive = TRUE)
    board <- pins::board_folder(board_path)
  }
  return(board)
}