
polls <- plyr::rbind.fill(polls2011, polls2014, polls2017) %>%
    mutate(MidDate = StartDate + (EndDate - StartDate) / 2) %>%
    gather(Party, VotingIntention, -StartDate, -EndDate, -MidDate, -Poll, -WikipediaDates) %>%
    mutate(Poll = str_trim(gsub("\\[.+\\]", "", Poll)),
           VotingIntention = gsub("\\[.+\\]", "", VotingIntention),
           VotingIntention = as.numeric(VotingIntention) / 100) %>%
    # clean up pollster names:
    mutate(Poll = gsub(".*[Ee]lection result", "Election result", Poll),
           Poll = gsub("Herald.Digi[Pp]oll", "Herald-Digipoll", Poll)) %>%
    arrange(MidDate)

test_that("Right number of pollsters", {
    expect_equal(length(unique(polls$Poll)), 8)
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

# polls %>% filter(EndDate - StartDate > 32)

test_that("Date ranges plausible", {
    expect_lt(with(polls, as.numeric(max(EndDate - StartDate))), 32)
    expect_equal(with(polls, as.numeric(min(EndDate - StartDate))), 0)
})

save(polls, file = "pkg1/data/polls.rda")


library(ggplot2)
library(scales)
library(forcats)

polls %>%
    mutate(Party = fct_reorder(Party, VotingIntention, .desc = TRUE),
           Poll = fct_relevel(Poll, "Election result")) %>%
    ggplot(aes(x = MidDate, y = VotingIntention, colour = Party, shape = Poll, linetype = Poll)) +
    geom_line(alpha = 0.5) +
    geom_point() +
    geom_smooth(aes(group = Party), se = FALSE, colour = "grey15") +
    scale_colour_manual(values = parties_v, guide = FALSE) +
    scale_y_continuous("Voting intention", label = percent) +
    facet_wrap(~Party, scales = "free_y") +
    theme_grey() +
    theme(legend.position = c(0.8, 0.15))
