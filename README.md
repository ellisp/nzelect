# nzelect and nzcensus
New Zealand election results, polling data and census results data in convenient form of two R packages.  Each of the two packages can be installed separately, but they have been developed together and get good results working together.

[![Travis-CI Build Status](https://travis-ci.org/ellisp/nzelect.svg?branch=master)](https://travis-ci.org/ellisp/nzelect)

## Installation
`nzelect` is on CRAN, but `nzcensus` is too large so will remain on GitHub only.

```r
# install stable version of nzelect from CRAN:
install.packages("nzelect")

# or install dev version of nzelect (with the very latest data) from GitHub:
devtools::install_github("ellisp/nzelect/pkg1")


# install nzcensus from GitHub:
devtools::install_github("ellisp/nzelect/pkg2")

library(nzelect)
library(nzcensus)
```


# nzelect

[![CRAN version](http://www.r-pkg.org/badges/version/nzelect)](http://www.r-pkg.org/pkg/nzelect)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/nzelect)](http://www.r-pkg.org/pkg/nzelect)

## Caveat and disclaimer

The New Zealand Electoral Commission had no involvement in preparing this package and bear no responsibility for any errors.  In the event of any uncertainty, refer to the definitive source materials on their website.

`nzelect` is a very small voluntary project.  Please report any issues or bugs on [GitHub](https://github.com/ellisp/nzelect/issues).

## Usage - 2002 to 2017 results by voting place

The election results are available in two main data frames:

* `distinct_voting_places` has one row for each distinct voting place that could be located in a geographical point
* `nzge` has one row for each combination of election year, voting place, party, electorate and voting type (Party or Candidate).  

The `voting_place_id` column is shared between `distinct_voting_places` and `nzge` and is the only column that should be used to join the two.

### Overall results
The code below replicates the published results for the 2011 election at http://www.electionresults.govt.nz/electionresults_2011/e9/html/e9_part1.html

```r
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
```

```
## `summarise()` regrouping output by 'party' (override with `.groups` argument)
```

```
## # A tibble: 25 x 3
##    party                   `Candidate Vote` `Party Vote`
##    <chr>                              <dbl>        <dbl>
##  1 National Party                   1027696      1058636
##  2 Labour Party                      762897       614937
##  3 Green Party                       155492       247372
##  4 New Zealand First Party            39892       147544
##  5 Conservative Party                 51678        59237
##  6 Maori Party                        39320        31982
##  7 Mana                               29872        24168
##  8 ACT New Zealand                    31001        23889
##  9 Informal Party Votes                  NA        19872
## 10 United Future                      18792        13443
## # ... with 15 more rows
```


### Comparing party and candidate votes of several parties

```r
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
```

```
## `summarise()` regrouping output by 'voting_place' (override with `.groups` argument)
```

```r
ggpairs(proportions, aes(colour = voting_type), columns = 3:5)
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)



### Geographical location of voting places

These are available from 2008 onwards and can be obtained by joining the `nzge` and `distinct_voting_places` data frames by the `voting_place_id` column.


```r
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
```

```
## `summarise()` regrouping output by 'voting_place_id' (override with `.groups` argument)
```

```
## Warning: Removed 1 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)

See this [detailed interactive map of of the 2014 general election](https://ellisp.shinyapps.io/NZ-general-election-2014/) 
built as a side product of this project.

### Rolling up results to Regional Council, Territorial Authority, or Area Unit
Because this package matches the location people actually voted with to boundaries 
of Regional Council, Territorial Authority and Area Unit it's possible to roll up 
voting behaviour to those categories.  However, a large number of votes cannot be
located this way.  And it needs to be remembered that people are not necessarily voting
near their normal place of residence.

```r
nzge %>%
    filter(election_year == 2017) %>%
    filter(voting_type == "Party") %>%
    left_join(distinct_voting_places, by = "voting_place_id") %>%
    group_by(REGC2014_N) %>%
    summarise(
        total_votes = sum(votes),
        proportion_national = round(sum(votes[party == "National Party"]) / total_votes, 3)) %>%
    arrange(proportion_national)
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```
## # A tibble: 17 x 3
##    REGC2014_N               total_votes proportion_national
##    <chr>                          <dbl>               <dbl>
##  1 Gisborne Region                19402               0.347
##  2 Nelson Region                  25317               0.354
##  3 <NA>                          462345               0.376
##  4 Wellington Region             254815               0.386
##  5 West Coast Region              15959               0.393
##  6 Northland Region               79713               0.404
##  7 Otago Region                  112242               0.408
##  8 Manawatu-Wanganui Region      113102               0.431
##  9 Tasman Region                  29183               0.432
## 10 Hawke's Bay Region             79729               0.442
## 11 Bay of Plenty Region          140818               0.466
## 12 Canterbury Region             282927               0.48 
## 13 Auckland Region               656654               0.483
## 14 Marlborough Region             24602               0.491
## 15 Taranaki Region                56442               0.494
## 16 Waikato Region                201022               0.496
## 17 Southland Region               48417               0.523
```

```r
# what are some of those NA Regions?:
nzge %>%
    filter(voting_type == "Party" & election_year == 2017) %>%
    left_join(distinct_voting_places, by = c("voting_place_id")) %>%
    filter(is.na(REGC2014_N)) %>%
    group_by(voting_place) %>%
    summarise(total_votes = sum(votes))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```
## # A tibble: 395 x 2
##    voting_place                                                                      total_votes
##    <chr>                                                                                   <dbl>
##  1 Advance Voting Place - Mobile Team                                                        210
##  2 Ashburton Hospital & Rest Homes Team - Taken in Rangitata                                 310
##  3 Auckland Hospital Mobile & Advance Voting                                                 816
##  4 Central Mobile Team                                                                       212
##  5 Chatham Islands Council Building, 9 Tuku Road, Waitangi                                   230
##  6 Christchurch Mobile Voting Facility One, Central Christchurch and South City Mall         982
##  7 Defence Force Team, Powles Road                                                            94
##  8 Duvauchelle Community Centre, Main Road                                                   185
##  9 Herald Island Community Hall, 57 Ferry Parade                                             274
## 10 Hospital & Rest Homes - Team 1 - Taken in New Plymouth                                    643
## # ... with 385 more rows
```

```r
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
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png)

## Usage - Opinion polls

Opinion poll data from 2002 onwards has been tidied and collated into a single data object, `polls`.  Note that at the time of writing, sample sizes are not yet available.  The example below illustrates use of the few years of polling data since the 2014 election, in conjunction with the `parties_v` object which provides colours to use in representing political parties in graphics.


```r
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
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

```
## Warning: The shape palette can deal with a maximum of 6 discrete values because more than 6 becomes
## difficult to discriminate; you have 8. Consider specifying shapes manually if you must have
## them.
```

```
## Warning: Removed 8 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png)

Note that it is not appropriate to frequently update the version of `nzelect` on CRAN, so polling data will generally be out of date.  The development version of `nzelect` from GitHub will be kept more up to date (but no promises exactly how much).

## Usage - convenience functions

### Allocating parliamentary seats
The `allocate_seats` function uses the Sainte-Lague allocation method to allocate seats to a Parliament given proportions or counts of vote per party.  When used with the default settings, it should give the same result as the New Zealand Electoral Commission; this means a five percent threshold to be included in the main algorithm, but parties below five percent of total votes but with at least one electorate seat get total seats proportionate to their votes.  Here is the `allocate_seats` function in action with the actual vote counts from the 2014 General Election:


```r
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
```

```
## $seats_df
##    proportionally_allocated electorate_seats final    party
## 1                        60               41    60 National
## 2                        32               27    32   Labour
## 3                        14                0    14    Green
## 4                        11                0    11  NZFirst
## 5                         0                0     0     Cons
## 6                         0                0     0  IntMana
## 7                         2                1     2    Maori
## 8                         1                1     1      Act
## 9                         0                1     1   United
## 10                        0                0     0    Other
## 
## $seats_v
## National   Labour    Green  NZFirst     Cons  IntMana    Maori      Act   United    Other 
##       60       32       14       11        0        0        2        1        1        0
```

```r
# Result if there were no 5% minimum threshold:
allocate_seats(votes, electorate = electorate, threshold = 0)$seats_v
```

```
## National   Labour    Green  NZFirst     Cons  IntMana    Maori      Act   United    Other 
##       56       30       13       10        5        2        2        1        1        1
```

### Weighting opinion polls

Two techniques are provided in the `weight_polls` function for aggregating opinion polls while giving more weight to more recent polls.  These methods aim to replicate the approaches of the [Pundit Poll of Polls](http://www.pundit.co.nz/content/poll-of-polls), which states it is based on FiveThirtyEight's method; and the [curia Market Research Public Poll Average](http://www.curia.co.nz/).  To date, exact replication of Pundit or curia's results has not been possible, probably due in part to the non-inclusion of sample size data so far in the `polls` data in `nzelect` package.

The example below shows the `weight_polls` function in action in combination with `allocate_seats`, comparing the outcomes of both methods of polling aggregation, on assumption that electorate seats stay as they are in early 2017 (in particular, that ACT, United Future, and Maori party all win at least one electorate seat as needed to keep them in running for the proportional representation part of the seat allocation process).

```r
# electorate seats for Act, Cons, Green, Labour, Mana, Maori, National, NZFirst, United,
# assuming that electorates stay as currently allocated.  This is critical particularly
# for ACT, Maori and United Future, who if they lose their single electorate seat each
# will not be represented in parliament
electorates <- c(1,0,0,27,0,1,41,1,1)

polls %>%
    filter(MidDate > "2014-12-30" & MidDate < "2017-09-21" & Party != "TOP") %>%
    mutate(wt_p = weight_polls(MidDate, method = "pundit", refdate = as.Date("2017-09-22")),
           wt_c = weight_polls(MidDate, method = "curia", refdate = as.Date("2017-09-22"))) %>%
    group_by(Party) %>%
    summarise(pundit_perc = round(sum(VotingIntention * wt_p, na.rm = TRUE) / sum(wt_p) * 100, 1),
              curia_perc = round(sum(VotingIntention * wt_c, na.rm = TRUE) / sum(wt_c) * 100, 1)) %>%
    ungroup() %>%
    mutate(pundit_seats = allocate_seats(pundit_perc, electorate = electorates)$seats_v,
           curia_seats = allocate_seats(curia_perc, electorate = electorates)$seats_v)
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```
## # A tibble: 9 x 5
##   Party         pundit_perc curia_perc pundit_seats curia_seats
##   <chr>               <dbl>      <dbl>        <dbl>       <dbl>
## 1 ACT                   0.5        0.6            1           1
## 2 Conservative          0.5        0.5            0           0
## 3 Green                 7.1        6.6            9           8
## 4 Labour               38.8       40.5           47          50
## 5 Mana                  0.1        0.1            0           0
## 6 Maori                 0.9        1.1            1           1
## 7 National             43.1       41.5           53          51
## 8 NZ First              7          7.2            9           9
## 9 United Future         0.1        0.1            1           1
```



# nzcensus examples



```r
library(nzcensus)
library(ggrepel)
ggplot(REGC2013, aes(x = PropPubAdmin2013, y = PropPartnered2013, label = REGC2013_N) ) +
    geom_point() +
    geom_text_repel(colour = "steelblue") +
    scale_x_continuous("Proportion of workers in public administration", label = percent) +
    scale_y_continuous("Proportion of individuals who stated status that have partners", label = percent) +
    ggtitle("New Zealand census 2013")
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png)


```r
ggplot(Meshblocks2013, aes(x = WGS84Longitude, y = WGS84Latitude, colour = MedianIncome2013)) +
    borders("nz", fill = terrain.colors(5)[3], colour = NA) +
    geom_point(alpha = 0.1) +
    coord_map(xlim = c(166, 179)) +
    theme_map() +
    ggtitle("Locations of centers of meshblocks in 2013 census") +
    scale_colour_gradientn(colours = c("blue", "white", "red"), label = dollar) +
    theme(legend.position = c(0.1, 0.6))
```

```
## Warning: Removed 642 rows containing missing values (geom_point).
```

![plot of chunk unnamed-chunk-10](figure/unnamed-chunk-10-1.png)




# combining nzcensus and nzelect

To be provided later.
