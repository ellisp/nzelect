require(testthat)
require(dplyr)

# Must match results from 
# http://www.electionresults.govt.nz/electionresults_2014/e9/html/e9_part1.html
expect_that(
    sum(filter(GE2014, Party == "National Party" & VotingType == "Party")$Votes),
    equals(1131501)
)

expect_that(
    sum(filter(GE2014, Party == "National Party" & VotingType == "Candidate")$Votes),
    equals(1081787)
)

expect_that(
    sum(filter(GE2014, Party == "Labour Party" & VotingType == "Party")$Votes),
    equals(604535)
)

expect_that(
    sum(filter(GE2014, Party == "Labour Party" & VotingType == "Candidate")$Votes),
    equals(801287)
)

expect_that(
    sum(filter(GE2014, Party == "New Zealand First Party" & VotingType == "Party")$Votes),
    equals(208300)
)

expect_that(
    sum(filter(GE2014, Party == "New Zealand First Party" & VotingType == "Candidate")$Votes),
    equals(73384)
)


expect_that(
    sum(filter(GE2014, Party == "Patriotic Revolutionary Front" & VotingType == "Candidate")$Votes),
    equals(48)
)
