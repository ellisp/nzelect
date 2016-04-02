library(nzelect)
library(dplyr)
library(shinyapps)

proportions <- GE2014 %>%
    filter(VotingType == "Party") %>%
    group_by(VotingPlace, Party) %>%
    summarise(Votes = sum(Votes)) %>%
    ungroup() %>%
    group_by(VotingPlace) %>%
    mutate(prop = Votes / sum(Votes)) %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    filter(VotingPlaceSuburb != "Chatham Islands") %>%
    mutate(lab = paste0("<center>", VotingPlace, "<br>", 
                        Party, ": ", Votes, " votes, ",
                        round(prop * 100), "%</center>")) %>%
    select(VotingPlace, Party, Votes, prop, WGS84Latitude, WGS84Longitude, lab) 

parties <- data_frame(
    party = c("Labour Party", "National Party", "Green Party",
             "New Zealand First Party", "Conservative", "Internet MANA", 
             "Maori Party", "ACT New Zealand"),
    colour = c("red", "darkblue", "green", "purple", "steelblue", "brown", 
               "black", "yellow")
)

save(parties, file = "examples/leaflet/parties.rda")
save(proportions, file = "examples/leaflet/proportions.rda")




deployApp("examples/leaflet", appName = "NZ-general-election-2014", account = "ellisp")

