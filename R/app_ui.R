#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    page_sidebar(
      title = "R/Pharma 2024 Haunted Quiz!",
      theme = bs_theme(
        bootswatch = "sketchy",
        base_font = font_google("Metal Mania")
      ),
      sidebar = sidebar(
        title = "More Information",
        open = FALSE,
        "More to come"
      ),
      card(
        card_header(
          class = "d-flex justify-content-between",
          "Choose your Haunted Place!",
          actionButton(
            "launch_quiz_question",
            "Begin Question"
          )
        ),
        full_screen = TRUE,
        mod_map_ui("map_1"),
      ),
      #mod_auth_info_ui("auth_info_1"),
      uiOutput("description"),
      verbatimTextOutput("debug")
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "shinyexample"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
