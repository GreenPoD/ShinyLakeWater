#don't alter this code its for a working application

library(shiny)
library(leaflet)
library(dplyr)
library(leaflet.extras)


#bootstrap page is javascript frienly
ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("lmap", width = "100%", height = "100%"),
  #fixed panel with selections (range, class, and full name)
  absolutePanel(top = 10, right = 10,
                titlePanel(h3("Great Lakes Water Quality")),
                sliderInput("range", "Select Timespan", min(great_lakes$year),
                            max(great_lakes$year),
                            value = range(great_lakes$year), step = 1),
                
                selectizeInput('class', label = NULL, 
                               choices = unique(great_lakes$classification),
                               multiple = TRUE,
                               options = list(placeholder = "Select Component Class")),
                
                selectizeInput('full_name', label = NULL, 
                               choices = unique(great_lakes$name), 
                               multiple = TRUE,
                               options = list(placeholder = "Select Component Name",
                                              onInitialize = I('function() { this.setValue(""); }')))
  )
)

server <- function(input, output, session) {
  
  classData <- reactive({
    great_lakes %>%
      filter(classification %in% input$class)
  })
  
  filteredData <- reactive({
    classData()[classData()$year >= input$range[1] & 
                  classData()$year <= input$range[2],]
  })
  
  subsetData <- reactive({
    classData()%>% 
      filter(name %in% input$full_name)
  })
  
  filteredSubsetData <- reactive({
    subsetData()[subsetData()$year >= input$range[1] & 
                   subsetData()$year <= input$range[2],]
  })
  
  #renders the static leaflet map ~ nothing that changes
  output$lmap <- renderLeaflet(
    leaflet(great_lakes) %>% 
      addProviderTiles(provider = "Esri.WorldGrayCanvas") %>%
      fitBounds(~min(lng)+0.5, ~min(lat) +0.5, ~max(lng), ~max(lat)) %>%
      #etView(lng = -80.617192, lat = 44.041866, zoom = 7) %>% 
      addResetMapButton() 
  )
  
  observe({
    #2nd level proxy that renders the classification data  
    leafletProxy("lmap", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(lng = ~lng, lat = ~lat, 
                 radius = ~mean_component / max(mean_component) * 20000, weight = 1,
                 color = "#777777", fillColor = ~colour_map, 
                 fillOpacity = 0.3, popup = ~paste(name, round(mean_component, 2), units, ", ", year))
  })
  
  #expression filters the choices available in the selectInput('name')
  observe({
    updateSelectizeInput(session, "full_name", choices = unique(classData()$name))
  })
  
  #leaflet map observer / proxy for filtered subset data
  observe({
    leafletProxy("lmap", data = filteredSubsetData()) %>%
      clearShapes() %>%
      addCircles(lng = ~lng, lat = ~lat, radius = ~mean_component / max(mean_component) * 20000, weight = 1,
                 color = "#777777", fillColor = ~colour_map,
                 fillOpacity = 0.3, popup = ~paste(name, round(mean_component, 2), units, ", ", year))
  })
  
}

shinyApp(ui = ui, server = server)

