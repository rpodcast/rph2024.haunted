#' question UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList icon
#' @importFrom shinyWidgets prettyRadioButtons
mod_question_ui <- function(
  id,
  quiz_question_text,
  correct_answer,
  incorrect_answer_1,
  incorrect_answer_2,
  incorrect_answer_3
) {
  ns <- NS(id)
  # shuffle order of choices
  quiz_choices = c(
    correct_answer,
    incorrect_answer_1,
    incorrect_answer_2,
    incorrect_answer_3
  )

  ind <- sample(1:length(quiz_choices), length(quiz_choices), replace = FALSE)
  quiz_choices <- quiz_choices[ind]

  tagList(
    prettyRadioButtons(
      ns("question"),
      label = quiz_question_text,
      choices = quiz_choices,
      selected = NULL,
      icon = icon("skull"),
      bigger = TRUE
    )
  )
}
    
#' question Server Functions
#'
#' @noRd 
mod_question_server <- function(
  id,
  quiz_question_text,
  correct_answer,
  incorrect_answer_1,
  incorrect_answer_2,
  incorrect_answer_3
){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # return selected answer from user
    user_answer <- reactive({
      req(input$question)
      input$question
    })

    user_answer
  })
}
    
## To be copied in the UI
# mod_question_ui("question_1")
    
## To be copied in the server
# mod_question_server("question_1")
