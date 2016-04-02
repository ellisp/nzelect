library(shiny)
library(leaflet)

load("parties.rda")

shinyUI(fluidPage(
  
  titlePanel("New Zealand General Election 2014 by polling place"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("party", "Select a Party to add to the map",
                   choices = c("", parties)),
       actionButton("clear", "Clear all parties")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       leafletOutput("MyMap", height = 800)
    )
  )
))
