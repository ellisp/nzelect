library(testthat)
library(dplyr)

# compare to http://www.electionresults.govt.nz/electionresults_2014/electorate-47.html

rotorua <- GE2014 %>%
    filter(Electorate == "Rotorua 47" & VotingType == "Candidate") %>%
    group_by(Candidate) %>%
    summarise(Votes = sum(Votes)) %>%
    arrange(desc(Votes))

expect_equal(
    tolower(as.character(rotorua[1, 1])),
    tolower("McClay, Todd Michael")
)

expect_equal(
    as.numeric(rotorua[1, 2]),
    18715
)

expect_equal(
    tolower(as.character(rotorua[6, 1])),
    tolower("russell, lyall")
)

expect_equal(
    as.numeric(rotorua[6, 2]),
    132
)
