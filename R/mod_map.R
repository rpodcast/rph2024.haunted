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

    # exclude map click input from bookmarks
    shiny::setBookmarkExclude("map_marker_click")

    # reactive for click selection of marker
    selected_click <- reactiveVal(NULL)

    # create icons for map
    icon_path <- "inst/app/www/map_icons"
    map_icons <- iconList(
      castle = makeIcon(
        iconUrl <- system.file("app", "www", "map_icons", "castle.png", package = "rph2024.haunted"),
        #iconUrl = fs::path(icon_path, "castle.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      dracula = makeIcon(
        iconUrl <- system.file("app", "www", "map_icons", "dracula.png", package = "rph2024.haunted"),
        #iconUrl = fs::path(icon_path, "dracula.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      ghost_face = makeIcon(
        iconUrl <- system.file("app", "www", "map_icons", "ghost-face.png", package = "rph2024.haunted"),
        #iconUrl = fs::path(icon_path, "ghost-face.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      ghost = makeIcon(
        iconUrl <- system.file("app", "www", "map_icons", "ghost.png", package = "rph2024.haunted"),
        #iconUrl = fs::path(icon_path, "ghost.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      pumpkin = makeIcon(
        iconUrl <- system.file("app", "www", "map_icons", "pumpkin.png", package = "rph2024.haunted"),
        #iconUrl = fs::path(icon_path, "pumpkin.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      skeleton = makeIcon(
        iconUrl <- system.file("app", "www", "map_icons", "skeleton.png", package = "rph2024.haunted"),
        #iconUrl = fs::path(icon_path, "skeleton.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      witch_hat = makeIcon(
        iconUrl <- system.file("app", "www", "map_icons", "witch-hat.png", package = "rph2024.haunted"),
        #iconUrl = fs::path(icon_path, "witch-hat.png"),
        iconWidth = 32,
        iconHeight = 32
      ),
      zombie_hand = makeIcon(
        iconUrl <- system.file("app", "www", "map_icons", "zombie_hand.png", package = "rph2024.haunted"),
        #iconUrl = fs::path(icon_path, "zombie_hand.png"),
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

    # register location selected
    observeEvent(input$map_marker_click, {
      req(input$map_marker_click)
      selected_click(input$map_marker_click)
    })

    # reset location selected if map body is clicked
    observeEvent(input$map_click, {
      selected_click(NULL)
    })

    # remove current selected marker if remove trigger
    observeEvent(remove_trigger(), {
      req(remove_trigger())
      req(selected_click())
      message("removing marker")
      click <- selected_click()
      proxy <- leafletProxy("map", data = map_data)
      proxy |>
        removeMarker(layerId = click$id)
      
      # reset selected item
      selected_click(NULL)
    })

    # reactive for location selected
    selected_location <- reactive({
      req(selected_click())
      click <- selected_click()
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
