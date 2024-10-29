#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import elmer
#' @importFrom markdown markdownToHTML
#' @noRd
app_server <- function(input, output, session) {
  # execute authentication information module
  user_info <- mod_auth_info_server("auth_info_1")

  # initialize chat bot
  chat <- elmer::chat_openai(
    model = "gpt-4o-mini",
    system_prompt = import_prompt_file(),
    echo = FALSE
  )

  # import data
  haunted_df <- process_haunted_data()

  # reactive values used in app logic
  start_app <- reactiveVal(TRUE)
  current_question <- reactiveVal(NULL)
  remove_trigger <- reactiveVal(NULL)
  remove_locations <- reactiveVal(NULL)
  current_question_df <- reactiveVal(NULL)
  user_question_df <- reactiveVal(NULL)

  # launch map module
  selected_location <- mod_map_server("map_1", haunted_df, remove_trigger)

  # Show welcome popup
  observeEvent(start_app(), {
    shiny::showModal(
      shiny::modalDialog(
        htmltools::includeMarkdown(
          system.file("docs", "welcome.md", package = "rph2024.haunted")
        ),
        title = NULL,
        easyClose = TRUE,
        footer = shiny::modalButton("I am Ready!"),
        size = "xl"
      )
    )
  })

  # reactive for filtered data based on selection
  haunted_subset_df <- reactive({
    req(selected_location())
    dplyr::filter(haunted_df, location == selected_location())
  })

  output$show_user_name <- renderUI({
    req(user_info())
    glue::glue("Welcome, {user_info()$user_name}! Choose a Haunted Place ... If You Dare!")
  })

  output$description <- renderUI({
    req(haunted_subset_df())
    card(
      card_header(haunted_subset_df()$location),
      full_screen = TRUE,
      tags$p(haunted_subset_df()$description)
    )
  })

  observeEvent(input$launch_quiz_question, {
    if (!shiny::isTruthy(haunted_subset_df())) {
      message("Nothing selected!")
      return(NULL)
    }
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
    # obtain current time of submissions
    current_time <- Sys.time()
    current_submission_info_df <- current_question_df()() |>
      dplyr::mutate(
        user_nickname = user_info()$user_nickname,
        user_name = user_info()$user_name,
        user_picture = user_info()$user_picture,
        submission_timestamp = current_time
      )
    remove_trigger(runif(1))
    remove_locations(c(remove_locations(), selected_location()))
    user_question_df(
      dplyr::bind_rows(
        user_question_df(),
        current_submission_info_df
      )
    )
    shiny::removeModal()
  })

  n_questions_submitted <- reactive({
    req(user_question_df())
    nrow(user_question_df())
  })

  n_questions_correct <- reactive({
    #req(user_question_df())
    if (is.null(user_question_df())) {
      return(0)
    } else {
      return(sum(user_question_df()$result))
    }
  })

  output$status <- renderUI({
    if (is.null(user_question_df())) {
      text <- "Don't be scared ... enter a haunted place and begin!"
    } else {
      text <- glue::glue("Escape Attempts: {n_questions_submitted()}         Successful Escapes: {n_questions_correct()}")
    }
    h2(text)
  })
}
