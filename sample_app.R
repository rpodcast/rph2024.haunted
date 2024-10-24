library(shiny)
library(leaflet)
library(bslib)
library(dplyr)

# Sample data - replace this with your actual data
locations_data <- data.frame(
  city = c("New York City", "Los Angeles", "Chicago"),
  state = c("New York", "California", "Illinois"),
  lat = c(40.7128, 34.0522, 41.8781),
  lng = c(-74.0060, -118.2437, -87.6298),
  fun_fact = c(
    "The New York Public Library has over 50 million items in its collection.",
    "The original name of Los Angeles was 'El Pueblo de Nuestra Señora la Reina de los Ángeles'.",
    "Chicago's nickname 'The Windy City' actually refers to politics, not weather."
  )
)

ui <- page_fluid(
  card(
    card_header("Interactive U.S. Locations Map"),
    leafletOutput("map"),
    textOutput("selected_fact")
  )
)

server <- function(input, output, session) {
  # Create the map
  output$map <- renderLeaflet({
    leaflet(locations_data) %>%
      addTiles() %>%  # Add default OpenStreetMap tiles
      addMarkers(
        ~lng, ~lat,
        popup = ~city,
        layerId = ~city  # Use city as the identifier for markers
      ) %>%
      setView(lng = -98.5795, lat = 39.8283, zoom = 4)  # Center on US
  })
  
  # Display fun fact when marker is clicked
  output$selected_fact <- renderText({
    click <- input$map_marker_click
    if (is.null(click))
      return("Click on a location to see its fun fact!")
    
    selected_location <- locations_data %>%
      filter(city == click$id)
    
    if (nrow(selected_location) > 0) {
      paste0(selected_location$city, ", ", selected_location$state, ": ",
             selected_location$fun_fact)
    }
  })
}

shinyApp(ui, server)
