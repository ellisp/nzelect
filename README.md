# nzelect
New Zealand election results data in convenient form of an R package


```r
library(ggplot2, quietly = TRUE)
library(scales, quietly = TRUE)
library(GGally, quietly = TRUE) # for ggpairs
library(gridExtra, quietly = TRUE) # for grid.arrange

proportions <- GE2014 %>%
    group_by(VotingPlace, VotingType) %>%
    summarise(ProportionLabour = sum(Votes[Party == "Labour Party"]) / sum(Votes),
              ProportionNational = sum(Votes[Party == "National Party"]) / sum(Votes),
              ProportionGreens = sum(Votes[Party == "Green Party"]) / sum(Votes),
              ProportionNZF = sum(Votes[Party == "New Zealand First Party"]) / sum(Votes),
              ProportionMaori = sum(Votes[Party == "Maori Party"]) / sum(Votes))

ggpairs(proportions, aes(colour = VotingType), columns = 3:5)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

