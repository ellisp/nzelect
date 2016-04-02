library(nzelect)
library(dplyr)
library(shinyapps)

proportions <- GE2014 %>%
    filter(VotingType == "Party") %>%
    group_by(VotingPlace) %>%
    summarise(ProportionLabour = sum(Votes[Party == "Labour Party"]) / sum(Votes),
              ProportionNational = sum(Votes[Party == "National Party"]) / sum(Votes),
              ProportionGreens = sum(Votes[Party == "Green Party"]) / sum(Votes),
              ProportionNZF = sum(Votes[Party == "New Zealand First Party"]) / sum(Votes),
              ProportionMaori = sum(Votes[Party == "Maori Party"]) / sum(Votes)) %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    filter(VotingPlaceSuburb != "Chatham Islands")

parties <- c("Labour Party", "National Party", "Green Party",
             "New Zealand First Party", "Maori Party")

save(parties, file = "examples/leaflet/parties.rda")
save(proportions, file = "examples/leaflet/proportions.rda")

deployApp("examples/leaflet", appName = "NZ-general-election-2014", account = "ellisp")
