#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggvis)

load("../data/geoMap.RData")


# Define UI for application that draws a map with clusters
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Map of WNV incidence rate and clustering"),
   
   # Sidebar with a slider input for number of clusters 
   sidebarLayout(
      sidebarPanel(
         sliderInput("clusters",
                     "Number of clusters:",
                     min = 1,
                     max = 20,
                     value = 6)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("mapPlot")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {

   output$mapPlot <- renderPlot({
      # generate clusters based on input$clusters from ui.R
      set.seed(123)
      geo.hot.cl <- kmeans(trap_geo_hot[,2:4], centers = input$clusters)
      trap_geo_hot$geo.hot.cl <- as.factor(geo.hot.cl$cluster)
      # draw the histogram with the specified number of bins
      trap_geo_hot %>% 
        ggvis(~Longitude, ~Latitude) + layer_points(fill := geo.hot.cl)
   })
})

# Run the application 
shinyApp(ui = ui, server = server)

