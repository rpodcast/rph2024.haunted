devtools::load_all()
library(dotenv)
library(elmer)

# import clean haunted data
df <- process_haunted_data()

chat <- chat_openai(
  model = "gpt-4o-mini",
  system_prompt = import_prompt_file(),
  echo = TRUE
)

# create_tool_def(display_quiz_question)

# test with a formatted string based on a selection of a place
df_sub <- df |>
  filter(location == "The Poet's Loft")

user_message <- glue::glue("Please create a fun quiz question using {df_sub$location} located at latitude {df_sub$city_latitude}, longitude {df_sub$city_longitude}, in the state of {df_sub$state}. Here is a description of the place: {df_sub$description}")

res <- chat$chat(user_message)

res2 <- jsonlite::fromJSON(txt = res)
