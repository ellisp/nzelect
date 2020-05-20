library(dplyr)
library(ggplot2)
library(nzelect)
library(forcats)
library(scales)

nzge %>%
    filter(grepl("BEFORE", voting_place, ignore.case = TRUE)) %>%
    filter(voting_type == "Candidate") %>%
    mutate(party = fct_reorder(party, votes),
           party = fct_lump(party, 6)) %>%
    group_by(party, election_year) %>%
    summarise(votes = sum(votes)) %>%
    ggplot(aes(x = votes, y = party)) +
    facet_wrap(~election_year) +
    geom_point() +
    scale_x_continuous("Votes before the election", label = comma)
           
           
           