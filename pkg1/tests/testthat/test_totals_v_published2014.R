require(testthat)
require(dplyr)

# Must match results from 
# http://www.electionresults.govt.nz/electionresults_2014/e9/html/e9_part1.html

GE2014 <- filter(nzge, election_year == 2014)

# absolute numbers
expect_equal(
    sum(filter(GE2014, party == "National Party" & voting_type == "Party")$votes),
    1131501
)

expect_equal(
    sum(filter(GE2014, party == "National Party" & voting_type == "Candidate")$votes),
    1081787
)

expect_equal(
    sum(filter(GE2014, party == "Labour Party" & voting_type == "Party")$votes),
    604535
)

expect_equal(
    sum(filter(nzge, election_year == 2014 & party == "Labour Party" & voting_type == "Party")$votes),
    604535
)

expect_equal(
    sum(filter(GE2014, party == "Labour Party" & voting_type == "Candidate")$votes),
    801287
)

expect_equal(
    sum(filter(GE2014, party == "New Zealand First Party" & voting_type == "Party")$votes),
    208300
)

expect_equal(
    sum(filter(GE2014, party == "New Zealand First Party" & voting_type == "Candidate")$votes),
    73384
)

expect_equal(
    sum(filter(nzge, election_year == 2014 & party == "New Zealand First Party" & voting_type == "Candidate")$votes),
    73384
)


expect_equal(
    sum(filter(GE2014, party == "Patriotic Revolutionary Front" & voting_type == "Candidate")$votes),
    48
)


# percentages
expect_equal(
    round(sum(filter(GE2014, party == "National Party" & voting_type == "Party")$votes) /
        sum(filter(GE2014, voting_type == "Party" & party != "Informal Party Votes")$votes) * 100, 2),
    47.04
 )


expect_equal(
    round(sum(filter(GE2014, party == "Green Party" & voting_type == "Candidate")$votes) /
              sum(filter(GE2014, voting_type == "Candidate" & party != "Informal Candidate Votes")$votes) * 100, 2),
    7.06
)