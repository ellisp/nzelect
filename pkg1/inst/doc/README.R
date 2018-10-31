## ----eval=FALSE----------------------------------------------------------
#  devvtools::install_github("ellisp/nzelect/pkg2")

## ------------------------------------------------------------------------
library(nzelect)
library(tidyr)
library(dplyr)
nzge %>%
    filter(election_year == 2011) %>%
    mutate(voting_type = paste0(voting_type, " Vote")) %>%
    group_by(party, voting_type) %>%
    summarise(votes = sum(votes)) %>%
    spread(voting_type, votes) %>%
    ungroup() %>%
    arrange(desc(`Party Vote`))


## ----fig.width = 7, fig.height = 7---------------------------------------

library(ggplot2, quietly = TRUE)
library(scales, quietly = TRUE)
library(GGally, quietly = TRUE) # for ggpairs
library(dplyr)

proportions <- nzge %>%
    filter(election_year == 2014) %>%
    group_by(voting_place, voting_type) %>%
    summarise(`proportion Labour` = sum(votes[party == "Labour Party"]) / sum(votes),
              `proportion National` = sum(votes[party == "National Party"]) / sum(votes),
              `proportion Greens` = sum(votes[party == "Green Party"]) / sum(votes),
              `proportion NZF` = sum(votes[party == "New Zealand First Party"]) / sum(votes),
              `proportion Maori` = sum(votes[party == "Maori Party"]) / sum(votes))

ggpairs(proportions, aes(colour = voting_type), columns = 3:5)



## ----fig.width = 7, fig.height = 5---------------------------------------
library(ggthemes) # for theme_map()
nzge %>%
    filter(voting_type == "Party" & election_year == 2014) %>%
    group_by(voting_place_id, election_year) %>%
    summarise(proportion_national = sum(votes[party == "National Party"] / sum(votes))) %>%
    left_join(distinct_voting_places, by = c("voting_place_id")) %>%
    mutate(mostly_national = ifelse(proportion_national > 0.5, 
                                   "Mostly voted National", "Mostly didn't vote National")) %>%
    ggplot(aes(x = longitude, y = latitude, colour = proportion_national)) +
    geom_point() +
    facet_wrap(~mostly_national) +
    coord_map() +
    borders("nz") +
    scale_colour_gradient2(label = percent, mid = "grey80", midpoint = 0.5) +
    theme_map() +
    theme(legend.position = c(0.04, 0.5)) +
    ggtitle("Voting patterns in the 2014 General Election\n")

## ----fig.width=7, fig.height=9-------------------------------------------
nzge %>%
    filter(election_year == 2017) %>%
    filter(voting_type == "Party") %>%
    left_join(distinct_voting_places, by = "voting_place_id") %>%
    group_by(REGC2014_N) %>%
    summarise(
        total_votes = sum(votes),
        proportion_national = round(sum(votes[party == "National Party"]) / total_votes, 3)) %>%
    arrange(proportion_national)
    
# what are some of those NA Regions?:
nzge %>%
    filter(voting_type == "Party" & election_year == 2017) %>%
    left_join(distinct_voting_places, by = c("voting_place_id")) %>%
    filter(is.na(REGC2014_N)) %>%
    group_by(voting_place) %>%
    summarise(total_votes = sum(votes))
    


nzge %>%
    filter(voting_type == "Party" & election_year == 2017) %>%
    left_join(distinct_voting_places, by = "voting_place_id") %>%
    group_by(TA2014_NAM) %>%
    summarise(
        total_votes = sum(votes),
        proportion_national = round(sum(votes[party == "National Party"]) / total_votes, 3)) %>%
    arrange(desc(proportion_national)) %>%
    mutate(TA = ifelse(is.na(TA2014_NAM), "Special or other", as.character(TA2014_NAM)),
           TA = gsub(" District", "", TA),
           TA = gsub(" City", "", TA),
           TA = factor(TA, levels = TA)) %>%
    ggplot(aes(x = proportion_national, y = TA, size = total_votes)) +
    geom_point() +
    scale_x_continuous("Proportion voting National Party", label = percent) +
    scale_size("Number of\nvotes cast", label = comma) +
    labs(y = "", title = "Voting in the New Zealand 2017 General Election by Territorial Authority")

## ----fig.width = 8-------------------------------------------------------
library(forcats)
polls %>%
    filter(MidDate > as.Date("2014-11-20") & !is.na(VotingIntention)) %>%
    filter(Party %in% c("National", "Labour", "Green", "NZ First")) %>%
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
    filter(MidDate > "2014-12-30" & MidDate < "2017-10-1" & Party != "TOP") %>%
    mutate(wt_p = weight_polls(MidDate, method = "pundit", refdate = as.Date("2017-09-22")),
           wt_c = weight_polls(MidDate, method = "curia", refdate = as.Date("2017-09-22"))) %>%
    group_by(Party) %>%
    summarise(pundit_perc = round(sum(VotingIntention * wt_p, na.rm = TRUE) / sum(wt_p) * 100, 1),
              curia_perc = round(sum(VotingIntention * wt_c, na.rm = TRUE) / sum(wt_c) * 100, 1)) %>%
    ungroup() %>%
    mutate(pundit_seats = allocate_seats(pundit_perc, electorate = electorates)$seats_v,
           curia_seats = allocate_seats(curia_perc, electorate = electorates)$seats_v)

