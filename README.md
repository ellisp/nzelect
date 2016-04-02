# nzelect
New Zealand election results data in convenient form of an R package


## Overall results
The code below replicates the published results at http://www.electionresults.govt.nz/electionresults_2014/e9/html/e9_part1.html

```r
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
```

```
## Source: local data frame [28 x 3]
## 
##                               Party PartyVote CandidateVote
##                               (chr)     (dbl)         (dbl)
## 1                    National Party   1131501       1081787
## 2                      Labour Party    604535        801287
## 3                       Green Party    257359        165718
## 4           New Zealand First Party    208300         73384
## 5                      Conservative     95598         81075
## 6                     Internet MANA     34094            NA
## 7                       Maori Party     31849         42108
## 8                   ACT New Zealand     16689         27778
## 9  Aotearoa Legalise Cannabis Party     10961          4936
## 10             Informal Party Votes     10857            NA
## ..                              ...       ...           ...
```


## Comparing party and candidate votes of several parties

```r
library(ggplot2, quietly = TRUE)
library(scales, quietly = TRUE)
library(GGally, quietly = TRUE) # for ggpairs
library(gridExtra, quietly = TRUE) # for grid.arrange
library(dplyr)

proportions <- GE2014 %>%
    group_by(VotingPlace, VotingType) %>%
    summarise(ProportionLabour = sum(Votes[Party == "Labour Party"]) / sum(Votes),
              ProportionNational = sum(Votes[Party == "National Party"]) / sum(Votes),
              ProportionGreens = sum(Votes[Party == "Green Party"]) / sum(Votes),
              ProportionNZF = sum(Votes[Party == "New Zealand First Party"]) / sum(Votes),
              ProportionMaori = sum(Votes[Party == "Maori Party"]) / sum(Votes))

ggpairs(proportions, aes(colour = VotingType), columns = 3:5)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png)



## Geographical location of voting places

```r
source("https://gist.githubusercontent.com/briatte/4718656/raw/2c4e71efe6d46f37e7ea264f5c9e1610511bcb09/ggplot2-map-theme.R")

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
    theme(legend.position = c(0.04, 0.55)) +
    ggtitle("Voting patterns in the 2014 General Election\n")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)

