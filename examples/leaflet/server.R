library(shiny)
library(leaflet)
library(dplyr)

load("proportions.rda")


shinyServer(function(input, output, session) {
    pal <- colorNumeric("Greens", c(0, 1))
    
    the_data <- reactive({
        tmp <- proportions 

        if(input$party == "Labour Party"){
                tmp$prop <- tmp$ProportionLabour
                thecol <- "red"
            } 
        if(input$party == "National Party"){
            tmp$prop <- tmp$ProportionNational
            thecol <- "blue"
        } 
        if(input$party == "Green Party"){
            tmp$prop <- tmp$ProportionGreen
            thecol <- "green"
        } 
        if(input$party == "New Zealand First Party"){
            tmp$prop <- tmp$ProportionNZF
            thecol <- "purple"
        } 
        if(input$party == "Maori Party"){
            tmp$prop <- tmp$ProportionMaori
            thecol <- "black"
        } 
        if(input$party == "") {
            tmp$prop <- 0
            thecol <- "white"
            
        }
            
        tmp <- tmp %>%
            mutate(lab = paste0("<center>", VotingPlace, "<br>", 
                                input$party, " ", 
                                round(prop * 100), "%</center>"))
            
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
        leafletProxy("MyMap") %>%
            clearMarkers()
    })


    
        
    observe({
        x <- input$sc
        leafletProxy("MyMap") %>% clearMarkers()
    })
    
   

  })
  
