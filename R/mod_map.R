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
mod_map_server <- function(
  id,
  map_data,
  remove_trigger = reactive(NULL)
) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    # create icons for map
    icon_path <- "inst/app/www/map_icons"
    map_icons <- iconList(
      castle = makeIcon(
        iconUrl = fs::path(icon_path, "castle.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      dracula = makeIcon(
        iconUrl = fs::path(icon_path, "dracula.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      ghost_face = makeIcon(
        iconUrl = fs::path(icon_path, "ghost-face.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      ghost = makeIcon(
        iconUrl = fs::path(icon_path, "ghost.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      pumpkin = makeIcon(
        iconUrl = fs::path(icon_path, "pumpkin.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      skeleton = makeIcon(
        iconUrl = fs::path(icon_path, "skeleton.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      witch_hat = makeIcon(
        iconUrl = fs::path(icon_path, "witch-hat.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      zombie_hand = makeIcon(
        iconUrl = fs::path(icon_path, "zombie_hand.png"),
        iconWidth = 32,
        iconHeight = 32
      )
    )
    
    # create map
    output$map <- renderLeaflet({
      leaflet(map_data) |>
        addTiles() |>
        addMarkers(
          ~longitude,
          ~latitude,
          popup = ~location,
          layerId = ~location,
          icon = ~map_icons[icon_type]
        ) |>
        setView(lng = -98.5795, lat = 39.8283, zoom = 4)
    })

    # remove current selected marker if remove trigger
    observeEvent(remove_trigger(), {
      req(remove_trigger())
      req(input$map_marker_click)
      message("removing marker")
      click <- input$map_marker_click
      proxy <- leafletProxy("map", data = map_data)
      proxy |>
        removeMarker(layerId = click$id)

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
