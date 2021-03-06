# ./prep/shiny_prep.R
# Peter Ellis, April 2016
# prepares data for the Shiny app to minimise calculations and payload needed
# for the actual server.

library(nzelect)
library(dplyr)
library(rsconnect)

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
    colour = c("red", "darkblue", "darkgreen", "purple", "steelblue", "brown", 
               "black", "yellow")
)

save(parties, file = "examples/leaflet/parties.rda")
save(proportions, file = "examples/leaflet/proportions.rda")



cat("Do you want to deploy the Shiny app: [Y/n]")
deploy <- readLines(n = 1)
if(tolower(deploy) == "y"){
    deployApp("examples/leaflet", appName = "NZ-general-election-2014", account = "ellisp")    
}


