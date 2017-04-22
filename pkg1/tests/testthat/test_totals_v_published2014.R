require(testthat)
require(dplyr)

# Must match results from 
# http://www.electionresults.govt.nz/electionresults_2014/e9/html/e9_part1.html

# absolute numbers
expect_equal(
    sum(filter(GE2014, Party == "National Party" & VotingType == "Party")$Votes),
    1131501
)

expect_equal(
    sum(filter(GE2014, Party == "National Party" & VotingType == "Candidate")$Votes),
    1081787
)

expect_equal(
    sum(filter(GE2014, Party == "Labour Party" & VotingType == "Party")$Votes),
    604535
)

expect_equal(
    sum(filter(GE2014, Party == "Labour Party" & VotingType == "Candidate")$Votes),
    801287
)

expect_equal(
    sum(filter(GE2014, Party == "New Zealand First Party" & VotingType == "Party")$Votes),
    208300
)

expect_equal(
    sum(filter(GE2014, Party == "New Zealand First Party" & VotingType == "Candidate")$Votes),
    73384
)


expect_equal(
    sum(filter(GE2014, Party == "Patriotic Revolutionary Front" & VotingType == "Candidate")$Votes),
    48
)


# percentages
expect_equal(
    round(sum(filter(GE2014, Party == "National Party" & VotingType == "Party")$Votes) /
        sum(filter(GE2014, VotingType == "Party" & Party != "Informal Party Votes")$Votes) * 100, 2),
    47.04
 )


expect_equal(
    round(sum(filter(GE2014, Party == "Green Party" & VotingType == "Candidate")$Votes) /
              sum(filter(GE2014, VotingType == "Candidate" & Party != "Informal Candidate Votes")$Votes) * 100, 2),
    7.06
)