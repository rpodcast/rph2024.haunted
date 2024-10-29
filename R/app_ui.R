#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bslib
#' @importFrom markdown markdownToHTML
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
        #base_font = font_google("Metal Mania"),
        base_font = font_google("Underdog"),
        heading_font = font_google("Underdog"),
        bg = "#2d1d47",
        fg = "#e7a11ef3"
      ),
      sidebar = sidebar(
        title = "More Information",
        open = FALSE,
        width = 350,
        htmltools::includeMarkdown(
          system.file("docs", "sidebar.md", package = "rph2024.haunted")
        )
      ),
      card(
        card_header(
          class = "bg-dark d-flex justify-content-between",
          uiOutput("show_user_name"),
          actionButton(
            "launch_quiz_question",
            "Begin Question",
            class = "btn-danger"
          )
        ),
        full_screen = TRUE,
        mod_map_ui("map_1"),
        class = "card_map"
      ),
      uiOutput("status"),
      uiOutput("description")
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
