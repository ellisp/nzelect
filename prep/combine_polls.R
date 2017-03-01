
polls <- plyr::rbind.fill(polls2008, polls2011, polls2014, polls2017) %>%
    mutate(MidDate = StartDate + (EndDate - StartDate) / 2) %>%
    gather(Party, VotingIntention, -StartDate, -EndDate, -MidDate, -Poll, -WikipediaDates) %>%
    mutate(Poll = str_trim(gsub("\\[.+\\]", "", Poll)),
           VotingIntention = gsub("\\[.+\\]", "", VotingIntention),
           VotingIntention = as.numeric(VotingIntention) / 100) %>%
    # clean up pollster names:
    mutate(Poll = gsub(".*[Ee]lection result", "Election result", Poll),
           Poll = gsub("Herald.Digi[Pp]oll", "Herald-Digipoll", Poll)) %>%
    arrange(MidDate) %>%
    mutate(Client = ifelse(grepl("Fairfax", Poll), "Fairfax Media", NA),
           Client = ifelse(grepl("Herald", Poll), "Herald", Client),
           Client = ifelse(grepl("3 New", Poll), "3 News", Client),
           Client = ifelse(grepl("One News", Poll), "One News", Client),
           Client = ifelse(grepl("Sunday Star", Poll), "Sunday Star Times", Client),
           Client = ifelse(grepl("Newshub", Poll), "Newshub", Client)) %>%
    mutate(Poll = gsub("Fairfax Media.", "", Poll),
           Poll = gsub("One News ", "", Poll),
           Poll = gsub("3 News ", "", Poll),
           Poll = gsub("Newshub ", "", Poll),
           Poll = gsub("Herald.", "", Poll),
           Poll = ifelse(grepl("Roy Morgan", Poll), "Roy Morgan", Poll),
           Poll = str_trim(gsub("Sunday Star.Times.", "", Poll))) %>%
    rename(Pollster = Poll)

table(polls$Client)
table(polls$Pollster)
test_that("Right number of pollsters", {
    expect_equal(length(unique(polls$Pollster)), 11)
})

test_that("Right number of parties", {
    expect_equal(length(unique(polls$Party)), 10)
})

# test all enddate, startdate, MidDate valid
test_that("Dates Valid", {
    expect_equal(sum(is.na(polls$StartDate)), 0)
    expect_equal(sum(is.na(polls$EndDate)), 0)    
    expect_equal(sum(is.na(polls$MidDate)), 0)    
})

test_that("Date ranges plausible", {
    expect_lt(with(polls, as.numeric(max(EndDate - StartDate))), 32)
    expect_equal(with(polls, as.numeric(min(EndDate - StartDate))), 0)
})

# polls %>% filter(EndDate - StartDate > 32 | EndDate < StartDate)

save(polls, file = "pkg1/data/polls.rda")


library(ggplot2)
library(scales)
library(forcats)

polls %>%
    mutate(Party = fct_reorder(Party, VotingIntention, .desc = TRUE),
           Poll = fct_relevel(Pollster, "Election result")) %>%
    ggplot(aes(x = MidDate, y = VotingIntention, linetype = Pollster)) +
    geom_line(alpha = 0.5) +
    geom_point(aes(colour = Client)) +
    geom_smooth(aes(group = Party), se = FALSE, colour = "grey15", span = .20) +
#    scale_colour_manual(values = parties_v, guide = FALSE) +
    scale_y_continuous("Voting intention", label = percent) +
    facet_wrap(~Party, scales = "free_y") +
    theme_grey() +
    theme(legend.position = c(0.8, 0.15))


# see https://github.com/diegovalle/Elections-2012/blob/master/src/kalman.R to adapt for kalman filter