
polls <- plyr::rbind.fill(polls2005, polls2008, polls2011, polls2014, polls2017) %>%
    mutate(MidDate = StartDate + (EndDate - StartDate) / 2) %>%
    gather(Party, VotingIntention, -StartDate, -EndDate, -MidDate, -Poll, -WikipediaDates) %>%
    mutate(Poll = str_trim(gsub("\\[.+\\]", "", Poll)),
           VotingIntention = gsub("\\[.+\\]", "", VotingIntention),
           VotingIntention = as.numeric(VotingIntention) / 100) %>%
    # clean up pollster names:
    mutate(Poll = gsub(".*[Ee]lection result", "Election result", Poll),
           Poll = gsub("Herald.Digi[Pp]oll", "Herald-Digipoll", Poll)) %>%
    mutate(Client = ifelse(grepl("Fairfax", Poll), "Fairfax Media", NA),
           Client = ifelse(grepl("Herald", Poll), "Herald", Client),
           Client = ifelse(grepl("3 New", Poll), "3 News", Client),
           Client = ifelse(grepl("TV3", Poll), "TV3", Client),
           Client = ifelse(grepl("NBR", Poll), "NBR", Client),
           Client = ifelse(grepl("One News", Poll), "One News", Client),
           Client = ifelse(grepl("Sunday Star", Poll), "Sunday Star Times", Client),
           Client = ifelse(grepl("Newshub", Poll), "Newshub", Client)) %>%
    mutate(Poll = gsub("Fairfax Media.", "", Poll),
           Poll = gsub("Fairfax New Zealand.", "", Poll),
           Poll = gsub("AC Niels.n", "Nielsen", Poll),
           Poll = gsub("One News ", "", Poll),
           Poll = gsub("3 News.", "", Poll),
           Poll = gsub("TV3.", "", Poll),
           Poll = gsub("NBR.", "", Poll),
           Poll = gsub("Newshub ", "", Poll),
           Poll = gsub("Herald.", "", Poll),
           Poll = ifelse(grepl("Roy Morgan", Poll), "Roy Morgan", Poll),
           Poll = str_trim(gsub("Sunday Star.Times.", "", Poll))) %>%
    mutate(Party = gsub("\n", " ", Party, fixed = TRUE),
           Party = gsub("^Con$", "Conservative", Party)) %>%
    rename(Pollster = Poll)


# identify non-duplicate version of election results
elections <- polls %>%
    dplyr::filter(Pollster == "Election result") %>%
    dplyr::filter(!is.na(VotingIntention)) %>%
    mutate(WikipediaDates = ifelse(WikipediaDates == "20 Sep 2014", "20 September 2014", WikipediaDates)) %>%
    mutate(WikipediaDates = ifelse(WikipediaDates == "26 Nov 2011", "26 November 2011", WikipediaDates)) %>%
    distinct()

# remove all the duplicate election results and put the
# non-duplicates back:
polls <- polls %>%
    filter(Pollster != "Election result") %>%
    rbind(elections) %>%
    arrange(EndDate, Pollster, Party)
    
# add in election years
polls <- polls %>%
    mutate(ElectionYear = 2017,
           ElectionYear = ifelse(MidDate <= "2014-09-20", 2014, ElectionYear),
           ElectionYear = ifelse(MidDate <= "2011-11-26", 2011, ElectionYear),
           ElectionYear = ifelse(MidDate <= "2008-11-08", 2008, ElectionYear),
           ElectionYear = ifelse(MidDate <= "2005-09-17", 2005, ElectionYear),
           ElectionYear = ifelse(MidDate == "2002-07-27", 2002, ElectionYear))


test_that("Right number of pollsters", {
    expect_equal(length(unique(polls$Pollster)), 13)
})

test_that("Right number of parties", {
    expect_equal(length(unique(polls$Party)), 12)
})



# test all enddate, startdate, MidDate valid
test_that("Dates Valid", {
    expect_equal(sum(is.na(polls$StartDate)), 0)
    expect_equal(sum(is.na(polls$EndDate)), 0)    
    expect_equal(sum(is.na(polls$MidDate)), 0)    
})
# polls %>% filter(is.na(StartDate))

test_that("Date ranges plausible", {
    expect_lt(with(polls, as.numeric(max(EndDate - StartDate))), 32)
    expect_equal(with(polls, as.numeric(min(EndDate - StartDate))), 0)
})

# polls %>% filter(EndDate - StartDate > 32 | EndDate < StartDate)

polls <- filter(polls, !is.na(VotingIntention))

save(polls, file = "pkg1/data/polls.rda")



library(ggplot2)
library(scales)
library(forcats)

election_dates <- polls %>%
    filter(Pollster == "Election result") %>%
    select(MidDate) %>%
    distinct()

polls %>%
    mutate(Party = fct_reorder(Party, VotingIntention, .desc = TRUE),
           Pollster = fct_relevel(Pollster, "Election result")) %>%
    ggplot(aes(x = MidDate, y = VotingIntention, linetype = Pollster)) +
    geom_line(alpha = 0.5) +
    geom_point(aes(colour = Client), size = 0.7) +
    geom_smooth(aes(group = Party), se = FALSE, colour = "grey15", span = .20) +
    scale_y_continuous("Voting intention", label = percent) +
    scale_x_date("") +
    facet_wrap(~Party, scales = "free_y") +
    geom_vline(xintercept = as.numeric(election_dates$MidDate), colour = "grey80") +
    theme_grey() 


print(polls %>%
    filter(Party == "Green") %>%
    mutate(Pollster = fct_lump(Pollster, 5)) %>%
    ggplot(aes(x = MidDate, y = VotingIntention, colour = Pollster)) +
#    facet_wrap(~ Pollster) +
    #geom_point(colour = parties_v["Green"]) +
    geom_point() +
    geom_smooth(span = 0.2, se = FALSE, colour = "grey10") +
    geom_vline(xintercept = as.numeric(election_dates$MidDate), colour = "grey80") +
    scale_y_continuous("Voting intention", label = percent) +
    labs(x = "") +
    ggtitle("Voting intention for the Green Party")
)

# see https://github.com/diegovalle/Elections-2012/blob/master/src/kalman.R to adapt for kalman filter