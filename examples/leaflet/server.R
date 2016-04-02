library(shiny)
library(leaflet)
library(dplyr)

load("proportions.rda")
load("parties.rda")

shinyServer(function(input, output, session) {
    # input <- data.frame(party = "Labour Party")
    the_data <- reactive({
        tmp <- proportions %>%
            filter(Party == input$party)
        
        if(input$party != ""){
            thecol <- data.frame(parties)[parties$party == input$party, "colour"]
        } else {
            tmp <- proportions[1,]
            thecol <- NULL
            
        }
            
        return(list(df = tmp, thecol = thecol))
        })

    output$MyMap <- renderLeaflet({
        leaflet() %>% 
            addProviderTiles("Stamen.Watercolor") %>%
            addProviderTiles("Stamen.TonerLabels") %>%
            fitBounds(174, -37, 177, -38)
    })
    
    observe({
     leafletProxy("MyMap", data = the_data()$df) %>%
            addCircleMarkers(~WGS84Longitude, 
                             ~WGS84Latitude,
                             color = the_data()$thecol,
                             radius = ~prop * 30 * input$sc,
                             popup = ~lab) 
    })
            
    observe({
        x <- input$clear1
        updateSelectInput(session, "party", selected = "")
        leafletProxy("MyMap") %>% clearMarkers()
    })

    observe({
        x <- input$sc
        leafletProxy("MyMap") %>% clearMarkers()
    })
    
    
    output$leg <- renderPlot({
        plot(1:10, 1:10, type = "n", bty = "n", axes = FALSE, xlab = "", ylab = "")
        legend(5, 5, parties$party, col = parties$colour, pch = 19, bty = "n")
    }, width = 300, height = 300)
    
   

  })
  
