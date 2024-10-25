library(dotenv)
library(elmer)

chat <- chat_openai(
  model = "gpt-4o-mini",
  system_prompt = "You are a friendly assistent who is knowleadgable on Halloween. The user will ask you to create a short story related to a particular haunted place in the United States.",
  echo = TRUE
)

live_console(chat)
