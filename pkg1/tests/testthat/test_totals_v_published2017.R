require(testthat)
require(dplyr)

# Must match results from 
# http://www.electionresults.govt.nz/electionresults_2017/statistics/overall-results-summary.html

GE2017 <- filter(nzge, election_year == 2017)
# absolute numbers
expect_equal(
    sum(filter(GE2017, party == "National Party" & voting_type == "Party")$votes),
    1152075
)

expect_equal(
    sum(filter(GE2017, party == "National Party" & voting_type == "Candidate")$votes),
    1114367
)

expect_equal(
    sum(filter(GE2017, party == "Labour Party" & voting_type == "Party")$votes),
    956184
)

expect_equal(
    sum(filter(GE2017, party == "Labour Party" & voting_type == "Candidate")$votes),
    958155
)

expect_equal(
    sum(filter(GE2017, party == "New Zealand First Party" & voting_type == "Party")$votes),
    186706
)

expect_equal(
    sum(filter(GE2017, party == "New Zealand First Party" & voting_type == "Candidate")$votes),
    137816
)


expect_equal(
    sum(filter(GE2017, party == "Democrats for Social Credit" & voting_type == "Candidate")$votes),
    1794
)


# percentages
expect_equal(
    round(sum(filter(GE2017, party == "National Party" & voting_type == "Party")$votes) /
        sum(filter(GE2017, voting_type == "Party" & party != "Informal Party Votes")$votes) * 100, 2),
    44.45
 )


expect_equal(
    round(sum(filter(GE2017, party == "Green Party" & voting_type == "Candidate")$votes) /
              sum(filter(GE2017, voting_type == "Candidate" & party != "Informal Candidate Votes")$votes) * 100, 2),
    6.91
)