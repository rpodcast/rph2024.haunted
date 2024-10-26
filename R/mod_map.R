#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList req reactive
#' @importFrom leaflet leafletOutput
mod_map_ui <- function(id) {
  ns <- NS(id)
  tagList(
    leafletOutput(ns("map"))
  )
}
    
#' map Server Functions
#' @import leaflet
#' @noRd 
mod_map_server <- function(id, map_data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # create map
    output$map <- renderLeaflet({
      leaflet(map_data) |>
        addTiles() |>
        addMarkers(
          ~longitude,
          ~latitude,
          popup = ~location,
          layerId = ~location
        ) |>
        setView(lng = -98.5795, lat = 39.8283, zoom = 4)
    })

    # reactive for location selected
    selected_location <- reactive({
      req(input$map_marker_click)
      click <- input$map_marker_click
      selected_location <- map_data |>
        dplyr::filter(location == click$id) |>
        dplyr::pull(location)
      return(selected_location)
    })

    selected_location
  })
}
    
## To be copied in the UI
# mod_map_ui("map_1")
    
## To be copied in the server
# mod_map_server("map_1")
