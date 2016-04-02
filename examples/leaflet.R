library(nzelect)
library(dplyr)
library(leaflet)

proportions <- GE2014 %>%
    filter(VotingType == "Party") %>%
    group_by(VotingPlace) %>%
    summarise(ProportionLabour = sum(Votes[Party == "Labour Party"]) / sum(Votes),
              ProportionNational = sum(Votes[Party == "National Party"]) / sum(Votes),
              ProportionGreens = sum(Votes[Party == "Green Party"]) / sum(Votes),
              ProportionNZF = sum(Votes[Party == "New Zealand First Party"]) / sum(Votes),
              ProportionMaori = sum(Votes[Party == "Maori Party"]) / sum(Votes)) %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    filter(VotingPlaceSuburb != "Chatham Islands") %>%
    mutate(lab = paste0("<center>", VotingPlace, "<br>", round(ProportionGreens * 100), "%</center>"))
    

pal <- colorNumeric("Greens", c(0, 1))

m <- leaflet(proportions) %>%
    addProviderTiles("Stamen.TonerHybrid") %>%
    addCircleMarkers( ~WGS84Longitude, 
               ~WGS84Latitude,
               color = "green",
               radius = ~ProportionGreens * 100,
               popup = ~lab) %>%
    fitBounds(173, -37, 176, -38)
library(htmlwidgets)
# saveWidget(m, file = "greens.html") # no good unless on a webserver
