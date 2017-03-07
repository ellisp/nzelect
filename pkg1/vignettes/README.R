## ----eval=FALSE----------------------------------------------------------
#  devvtools::install_github("ellisp/nzelect/pkg2")

## ------------------------------------------------------------------------
library(nzelect)
library(tidyr)
library(dplyr)
GE2014 %>%
    mutate(VotingType = paste0(VotingType, "Vote")) %>%
    group_by(Party, VotingType) %>%
    summarise(Votes = sum(Votes)) %>%
    spread(VotingType, Votes) %>%
    select(Party, PartyVote, CandidateVote) %>%
    ungroup() %>%
    arrange(desc(PartyVote))


## ----fig.width = 7, fig.height = 7---------------------------------------

library(ggplot2, quietly = TRUE)
library(scales, quietly = TRUE)
library(GGally, quietly = TRUE) # for ggpairs
library(dplyr)

proportions <- GE2014 %>%
    group_by(VotingPlace, VotingType) %>%
    summarise(ProportionLabour = sum(Votes[Party == "Labour Party"]) / sum(Votes),
              ProportionNational = sum(Votes[Party == "National Party"]) / sum(Votes),
              ProportionGreens = sum(Votes[Party == "Green Party"]) / sum(Votes),
              ProportionNZF = sum(Votes[Party == "New Zealand First Party"]) / sum(Votes),
              ProportionMaori = sum(Votes[Party == "Maori Party"]) / sum(Votes))

ggpairs(proportions, aes(colour = VotingType), columns = 3:5)



## ----fig.width = 7, fig.height = 5---------------------------------------
library(ggthemes) # for theme_map()
GE2014 %>%
    filter(VotingType == "Party") %>%
    group_by(VotingPlace) %>%
    summarise(ProportionNational = sum(Votes[Party == "National Party"] / sum(Votes))) %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    filter(VotingPlaceSuburb != "Chatham Islands") %>%
    mutate(MostlyNational = ifelse(ProportionNational > 0.5, 
                                   "Mostly voted National", "Mostly didn't vote National")) %>%
    ggplot(aes(x = WGS84Longitude, y = WGS84Latitude, colour = ProportionNational)) +
    geom_point() +
    facet_wrap(~MostlyNational) +
    coord_map() +
    borders("nz") +
    scale_colour_gradient2(label = percent, mid = "grey80", midpoint = 0.5) +
    theme_map() +
    theme(legend.position = c(0.04, 0.5)) +
    ggtitle("Voting patterns in the 2014 General Election\n")

## ----fig.width=7, fig.height=9-------------------------------------------
GE2014 %>%
    filter(VotingType == "Party") %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    group_by(REGC2014_N) %>%
    summarise(
        TotalVotes = sum(Votes),
        ProportionNational = round(sum(Votes[Party == "National Party"]) / TotalVotes, 3)) %>%
    arrange(ProportionNational)
    
# what are all those NA Regions?:
GE2014 %>%
    filter(VotingType == "Party") %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    filter(is.na(REGC2014_N)) %>%
    group_by(VotingPlace) %>%
    summarise(TotalVotes = sum(Votes))
    


GE2014 %>%
    filter(VotingType == "Party") %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    group_by(TA2014_NAM) %>%
    summarise(
        TotalVotes = sum(Votes),
        ProportionNational = round(sum(Votes[Party == "National Party"]) / TotalVotes, 3)) %>%
    arrange(desc(ProportionNational)) %>%
    mutate(TA = ifelse(is.na(TA2014_NAM), "Special or other", as.character(TA2014_NAM)),
           TA = gsub(" District", "", TA),
           TA = gsub(" City", "", TA),
           TA = factor(TA, levels = TA)) %>%
    ggplot(aes(x = ProportionNational, y = TA, size = TotalVotes)) +
    geom_point() +
    scale_x_continuous("Proportion voting National Party", label = percent) +
    scale_size("Number of\nvotes cast", label = comma) +
    labs(y = "", title = "Voting in the New Zealand 2014 General Election by Territorial Authority")



## ----fig.width = 8-------------------------------------------------------
library(forcats)
polls %>%
filter(MidDate > as.Date("2014-11-20") & !is.na(VotingIntention)) %>%
    mutate(Party = fct_reorder(Party, VotingIntention, .desc = TRUE),
           Party = fct_drop(Party)) %>%
    ggplot(aes(x = MidDate, y = VotingIntention, colour = Party, linetype = Pollster)) +
    geom_line(alpha = 0.5) +
    geom_point(aes(shape = Pollster)) +
    geom_smooth(aes(group = Party), se = FALSE, colour = "grey15", span = .4) +
    scale_colour_manual(values = parties_v) +
    scale_y_continuous("Voting intention", label = percent) +
    scale_x_date("") +
    facet_wrap(~Party, scales = "free_y") 

## ------------------------------------------------------------------------
votes <- c(National = 1131501, Labour = 604535, Green = 257359,
           NZFirst = 208300, Cons = 95598, IntMana = 34094, 
           Maori = 31849, Act = 16689, United = 5286,
           Other = 20411)
electorate = c(41, 27, 0, 
               0, 0, 0, 
               1, 1, 1,
               0)
               
# Actual result:               
allocate_seats(votes, electorate = electorate)

# Result if there were no 5% minimum threshold:
allocate_seats(votes, electorate = electorate, threshold = 0)$seats_v

## ------------------------------------------------------------------------
# electorate seats for Act, Cons, Green, Labour, Mana, Maori, National, NZFirst, United,
# assuming that electorates stay as currently allocated.  This is critical particularly
# for ACT, Maori and United Future, who if they lose their single electorate seat each
# will not be represented in parliament
electorates <- c(1,0,0,27,0,1,41,1,1)

polls %>%
    filter(MidDate > "2014-12-30" & MidDate < "2017-10-1") %>%
    mutate(wt_p = weight_polls(MidDate, method = "pundit"),
           wt_c = weight_polls(MidDate, method = "curia")) %>%
    group_by(Party) %>%
    summarise(pundit_perc = round(sum(VotingIntention * wt_p, na.rm = TRUE) / sum(wt_p) * 100, 1),
              curia_perc = round(sum(VotingIntention * wt_c, na.rm = TRUE) / sum(wt_c) * 100, 1)) %>%
    ungroup() %>%
    filter(pundit_perc > 0) %>%
    mutate(pundit_seats = allocate_seats(pundit_perc, electorate = electorates)$seats_v,
           curia_seats = allocate_seats(curia_perc, electorate = electorates)$seats_v)

