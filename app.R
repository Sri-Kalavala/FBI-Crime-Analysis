
# app.R

library(shiny)
library(tidyverse)
library(leaflet)
library(shinythemes)

# Load data
crime_data <- read.csv("hate_crime.csv")
crime_data$data_year <- as.numeric(crime_data$data_year)

ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel("U.S. Hate Crime Dashboard"),
  sidebarLayout(
    sidebarPanel(
      selectInput("offense", "Offense Type:", choices = unique(crime_data$offense_name)),
      sliderInput("yearRange", "Year Range:",
                  min = min(crime_data$data_year, na.rm = TRUE),
                  max = max(crime_data$data_year, na.rm = TRUE),
                  value = range(crime_data$data_year, na.rm = TRUE),
                  step = 1),
      selectInput("state", "State:", choices = c("All", unique(crime_data$state_name))),
      selectInput("bias", "Bias Description:", choices = c("All", unique(crime_data$bias_desc))),
      selectInput("location", "Location Type:", choices = c("All", unique(crime_data$location_name)))
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Overview",
                 textOutput("summaryText"),
                 plotOutput("crimePlot"),
                 plotOutput("biasPlot"),
                 plotOutput("locationPlot")
        ),
        tabPanel("Trends",
                 plotOutput("yearTrend"),
                 textOutput("predictionText")
        ),
        tabPanel("Map",
                 leafletOutput("crimeMap", height = 500)
        ),
        tabPanel("Data Table",
                 dataTableOutput("dataTable")
        )
      )
    )
  )
)

server <- function(input, output) {
  filtered_data <- reactive({
    df <- crime_data %>%
      filter(offense_name == input$offense,
             data_year >= input$yearRange[1],
             data_year <= input$yearRange[2])
    if (input$state != "All") df <- df %>% filter(state_name == input$state)
    if (input$bias != "All") df <- df %>% filter(bias_desc == input$bias)
    if (input$location != "All") df <- df %>% filter(location_name == input$location)
    df
  })
  
  output$crimePlot <- renderPlot({
    filtered_data <- crime_data %>%
      filter(offense_name == input$offense, data_year >= input$yearRange[1], data_year <= input$yearRange[2])
    
    ggplot(filtered_data, aes(x = state_name)) +
      geom_bar(fill = "darkblue") +
      theme_minimal() +
      ggtitle(paste("Crimes in", input$offense, "by State")) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8))  # Slanted & smaller font here
  })
  
  output$crimePlot <- renderPlot({
    ggplot(filtered_data(), aes(x = state_name)) +
      geom_bar(fill = "darkblue") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      ggtitle("Crimes by State")
  })
  
  output$biasPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = bias_desc)) +
      geom_bar(fill = "darkred") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      ggtitle("Crimes by Bias Type")
  })
  
  output$locationPlot <- renderPlot({
    ggplot(filtered_data(), aes(x = location_name)) +
      geom_bar(fill = "darkgreen") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      ggtitle("Crimes by Location Type")
  })
  
  output$yearTrend <- renderPlot({
    df <- filtered_data() %>%
      group_by(data_year) %>%
      summarise(count = n())
    ggplot(df, aes(x = data_year, y = count)) +
      geom_line(color = "steelblue", size = 1.5) +
      geom_point(color = "black") +
      theme_minimal() +
      ggtitle("Crimes Over Time")
  })
  
  output$predictionText <- renderText({
    df <- filtered_data() %>%
      group_by(data_year) %>%
      summarise(count = n())
    model <- lm(count ~ data_year, data = df)
    next_year <- max(df$data_year) + 1
    prediction <- predict(model, newdata = data.frame(data_year = next_year))
    paste("Predicted hate crimes for", next_year, ":", round(prediction))
  })
  
  output$crimeMap <- renderLeaflet({
    state_crimes <- filtered_data() %>%
      count(state_name, sort = TRUE)
    
    # Dummy lat/lon (ideally should use a proper state lookup)
    state_coords <- data.frame(
      state_name = state.name,
      lat = state.center$y,
      lon = state.center$x
    )
    map_data <- merge(state_crimes, state_coords, by = "state_name")
    
    leaflet(map_data) %>%
      addTiles() %>%
      addCircles(
        lng = ~lon, lat = ~lat,
        weight = 1, radius = ~n * 1000,
        popup = ~paste(state_name, ":", n, "crimes")
      )
  })
  
  output$dataTable <- renderDataTable({
    filtered_data()
  })
}

shinyApp(ui = ui, server = server)
