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
  current_question <- reactiveVal(NULL)
  remove_trigger <- reactiveVal(NULL)
  remove_locations <- reactiveVal(NULL)
  current_question_df <- reactiveVal(NULL)
  user_question_df <- reactiveVal(NULL)
  #n_questions_submitted <- reactiveVal(0)
  #n_questions_correct <- reactiveVal(0)

  # launch map module
  selected_location <- mod_map_server("map_1", haunted_df, remove_trigger)

  # reactive for filtered data based on selection
  haunted_subset_df <- reactive({
    req(selected_location())
    dplyr::filter(haunted_df, location == selected_location())
  })

  observeEvent(input$launch_quiz_question, {
    req(haunted_subset_df())
    message("begin question processing")
    user_prompt <- prepare_user_prompt(
      haunted_subset_df()$location,
      haunted_subset_df()$latitude,
      haunted_subset_df()$longitude,
      haunted_subset_df()$state,
      haunted_subset_df()$description
    )

    # obtain question
    question_raw <- chat$chat(user_prompt)
    question_processed <- import_quiz_question(question_raw)
    current_question(question_processed)
    message("done with getting question")
    
    shiny::showModal(
      shiny::modalDialog(
        title = "Here is your question",
        mod_question_ui(
          id = haunted_subset_df()$location,
          location = haunted_subset_df()$location,
          quiz_question_text = question_processed$quiz_question_text,
          correct_answer = question_processed$correct_answer,
          incorrect_answer_1 = question_processed$incorrect_answer_1,
          incorrect_answer_2 = question_processed$incorrect_answer_2,
          incorrect_answer_3 = question_processed$incorrect_answer_3
        ),
        footer = tagList(
          shiny::modalButton("Get me out of here!"),
          shiny::actionButton("submit_answer", "Submit Answer")
        ),
        size = "xl",
        easyClose = FALSE
      )
    )

    question_answer <- mod_question_server(
      id = haunted_subset_df()$location,
      location = haunted_subset_df()$location,
      quiz_question_text = question_processed$quiz_question_text,
      correct_answer = question_processed$correct_answer,
      incorrect_answer_1 = question_processed$incorrect_answer_1,
      incorrect_answer_2 = question_processed$incorrect_answer_2,
      incorrect_answer_3 = question_processed$incorrect_answer_3
    )
    current_question_df(question_answer)
  })

  observeEvent(input$submit_answer, {
    remove_trigger(runif(1))
    remove_locations(c(remove_locations(), selected_location()))
    user_question_df(
      dplyr::bind_rows(
        user_question_df(),
        current_question_df()()
      )
    )
    shiny::removeModal()
  })

  n_questions_submitted <- reactive({
    req(user_question_df())
    nrow(user_question_df())
  })

  n_questions_correct <- reactive({
    req(user_question_df())
    sum(user_question_df()$result)
  })

  output$debug <- renderPrint({
    req(user_question_df())
    user_question_df()
  })
}
