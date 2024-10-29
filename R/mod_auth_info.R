#' auth_info UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_auth_info_ui <- function(id) {
  ns <- NS(id)
  tagList(
    verbatimTextOutput(ns("user_info"))
  )
}
    
#' auth_info Server Functions
#'
#' @noRd 
mod_auth_info_server <- function(id){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
 
    user_info <- reactive({
      if (getOption("auth0_disable")) {
        funny_name <- random_name()
        info <- list(
          sub = "devaccount|8675309",
          nickname = funny_name,
          name = funny_name,
          picture = "https://shinydevseries-assets.us-east-1.linodeobjects.com/megaman.png"
        )
      } else {
        info <- session$userData$auth0_info
      }

      return(info)
    })

    output$user_info <- renderPrint({
      user_info()
    })

    # return user metadata
    reactive({
      req(user_info())
      list(
        user_nickname = user_info()$sub,
        user_name = user_info()$name,
        user_picture = user_info()$picture
      )
    })
 
  })
}
    
## To be copied in the UI
# mod_auth_info_ui("auth_info_1")
    
## To be copied in the server
# mod_auth_info_server("auth_info_1")
