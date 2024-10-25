library(duckplyr)

count_words <- function(x) {
  words <- stringr::str_split(x, "\\s+")[[1]]
  word_count <- length(words)
  return(word_count)
}

haunted_df <- duckplyr_df_from_csv("data/haunted_places.csv")

haunted_df <- haunted_df |>
  mutate(n_words = count_words(description), .by = c(location)) |>
  arrange(state_abbrev, desc(n_words)) |>
  filter(!(is.na(city_latitude) & is.na(latitude))) |>
  slice_max(n_words, n = 4, by = state_abbrev)
