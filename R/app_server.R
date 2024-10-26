#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import elmer
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  # initialize chat bot
  chat <- chat_openai(
    model = "gpt-4o-mini",
    system_prompt = import_prompt_file(),
    echo = FALSE
  )

  # import data
  haunted_df <- process_haunted_data()

  # reactive values used in app logic
  # TODO: Add reactive values

  # launch map module
  selected_location <- mod_map_server("map_1", haunted_df)

  # reactive for filtered data based on selection
  haunted_subset_df <- reactive({
    req(selected_location())
    dplyr::filter(haunted_df, location == selected_location())
  })

  output$debug <- renderPrint({
    req(haunted_subset_df())
    str(haunted_subset_df())
  })
}
