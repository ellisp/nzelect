test_that("polls data are plausible", {
    # correct number of dimensions and column names:
    expect_equal(length(dim(polls)), 2)
    expect_equal(names(polls), c("Pollster", "WikipediaDates", "StartDate",
                                 "EndDate", "MidDate", "Party", "VotingIntention",
                                 "Client", "ElectionYear"))
    
    # at least five parties on average per poll
    expect_lt(length(unique(polls$MidDate)) / length(polls$MidDate), 1/5)
    
    # no more than 13 parties per poll on average
    expect_gt(length(unique(polls$MidDate)) / length(polls$MidDate), 1/13)
    
    # individual polls add up to nearly 1
    totals <- with(polls, tapply(VotingIntention, paste(Pollster, MidDate), sum, na.rm = TRUE))
    expect_gt(min(totals), 0.82) # 2005 data go down to 0.822 of voters, omitting some minor parties
    expect_lt(max(totals), 1.02)
})

