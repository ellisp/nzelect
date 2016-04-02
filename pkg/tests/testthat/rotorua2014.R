library(testthat)
library(dplyr)

# compare to http://www.electionresults.govt.nz/electionresults_2014/electorate-47.html

rotorua <- GE2014 %>%
    filter(Electorate == "Rotorua 47" & VotingType == "Candidate") %>%
    group_by(Candidate) %>%
    summarise(Votes = sum(Votes)) %>%
    arrange(desc(Votes))

expect_that(
    tolower(as.character(rotorua[1, 1])),
    equals(tolower("McClay, Todd Michael"))
)

expect_that(
    as.numeric(rotorua[1, 2]),
    equals(18715)
)

expect_that(
    tolower(as.character(rotorua[6, 1])),
    equals(tolower("russell, lyall"))
)

expect_that(
    as.numeric(rotorua[6, 2]),
    equals(132)
)
