# # Example

library(ggplot2)
library(scales)
library(GGally) # for ggpairs
library(gridExtra) # for grid.arrange

proportions <- results_voting_place_2014 %>%
    group_by(Polling_Place, VotingType) %>%
    summarise(ProportionLabour = sum(Votes[Party == "Labour Party"]) / sum(Votes),
              ProportionNational = sum(Votes[Party == "National Party"]) / sum(Votes),
              ProportionGreens = sum(Votes[Party == "Green Party"]) / sum(Votes),
              ProportionNZF = sum(Votes[Party == "New Zealand First Party"]) / sum(Votes),
              ProportionMaori = sum(Votes[Party == "Maori Party"]) / sum(Votes))

ggpairs(proportions, aes(colour = VotingType), columns = 3:7)

#----------------------------candidate v party vote for Labour and Greens---------------
p1 <- proportions %>%
    select(Polling_Place, VotingType, ProportionLabour) %>%
    spread(VotingType, ProportionLabour) %>%
    ggplot(aes(x = Candidate, y = Party)) +
    geom_point() +
    geom_abline(intercept = 0, slope = 1, colour = "blue", size = 2) +
    scale_x_continuous(label = percent) + 
    scale_y_continuous(label = percent) +
    ggtitle("In the 2014 General Election by voting location,\nLabour candidate vote usually exceeded the party vote") +
    labs(x = "Proportion of Candidate Vote for Labour",
         y = "Proportion of Party Vote for Labour") +
    annotate("text", x = 0.1, y = 0.6, label = "Blue line shows\nequality of the two\nvoting types",
             colour = "blue")



p2 <- proportions %>%
    select(Polling_Place, VotingType, ProportionGreens) %>%
    spread(VotingType, ProportionGreens) %>%
    ggplot(aes(x = Candidate, y = Party)) +
    geom_point() +
    geom_abline(intercept = 0, slope = 1, colour = "blue", size = 2) +
    scale_x_continuous(label = percent) + 
    scale_y_continuous(label = percent) +
    ggtitle("The situation is reversed for Greens party;\nthere's a well known phenomenon of candidate vote for Labour, party vote for Greens") +
    labs(x = "Proportion of Candidate Vote for Greens",
         y = "Proportion of Party Vote for Greens") +
    annotate("text", x = 0.4, y = 0.1, label = "Blue line shows\nequality of the two\nvoting types",
             colour = "blue")

tmp <- proportions %>%
    select(Polling_Place, VotingType, ProportionNational) %>%
    spread(VotingType, ProportionNational) 
p3 <- tmp %>%
    ggplot(aes(x = Candidate, y = Party)) +
    geom_point() +
    geom_abline(intercept = 0, slope = 1, colour = "blue", size = 2) +
    scale_x_continuous(label = percent) + 
    scale_y_continuous(label = percent) +
    ggtitle("For the National Party, candidate and party vote are more closely aligned\nbut there is an interesting cluster of voting locations with low candidate vote but high party vote") +
    labs(x = "Proportion of Candidate Vote for National Party",
         y = "Proportion of Party Vote for National Party") +
    stat_ellipse(data = filter(tmp, Party > 2 * Candidate & Party > 0.5), colour = "red") +
    annotate("text", x = 0.7, y = 0.1, label = "Blue line shows\nequality of the two\nvoting types",
             colour = "blue")

grid.arrange(p1, p2, p3)

