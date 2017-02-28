#=====================polls pre 2017 election===================================
url <- "https://en.wikipedia.org/wiki/Opinion_polling_for_the_New_Zealand_general_election,_2017"

polls <- url %>%
    read_html(encoding = "UTF-8") 

tabs <- polls %>%
    html_nodes("table") 

tab <- html_table(tabs[[1]], fill = TRUE) 

tab <- tab[tab[ , 1] != tab[ , 2], 1:11]
tab <- tab[tab[ , 1] != "Poll", ]
names(tab)[2] <- "WikipediaDates"

tab$StartDate <- 
    as.Date(c("20/9/2014", "29/9/2014", "27/10/2014", "24/11/2014", "8/12/2014", "5/1/2015",
              "20/1/2015", "2/2/2015", "14/2/2015", "2/3/2015", "11/4/2015", "6/4/2015",
              "17/4/2015", "4/5/2015", "23/5/2015",
              "21/5/2015", "8/6/2015", "29/6/2015",
              "11/7/2015", "15/7/2015", "3/8/2015",
              "14/8/2015", "29/8/2015", "31/8/2015",
              "8/9/2015", "30/9/2015", "10/10/2015",
              "26/10/2015", "1/11/2015", "23/11/2015",
              "4/12/2015", "4/1/2016", "1/2/2016",
              "13/2/2016", "29/2/2016", "2/4/2016",
              "4/4/2016", "2/5/2016", "24/5/2016",
              "28/5/2016", "12/6/2016", "17/7/2016",
              "22/7/2016", "8/8/2016", "3/9/2016",
              "5/9/2016", "10/10/2016", "12/11/2016",
              "24/10/2016", "28/11/2016", "3/1/2017",
              "11/2/2017"),
            format = "%d/%m/%Y")

tab$EndDate <- as.Date(c("20/9/2014", "12/10/2014", "9/11/2014",
                         "7/12/2014", "21/12/2014", "18/1/2015",
                         "28/1/2015", "15/2/2015", "18/2/2015",
                         "15/3/2015", "15/4/2015", "19/4/2015",
                         "26/4/2015", "17/5/2015", "27/5/2015",
                         "27/5/2015", "21/6/2015", "12/7/2015",
                         "15/7/2015", "22/7/2015", "16/8/2015",
                         "24/8/2015", "2/9/2015", "13/9/2015",
                         "16/9/2015", "11/10/2015", "14/10/2015",
                         "8/11/2015", "30/11/2015", "6/12/2015",
                         "14/12/2015", "17/1/2016", "14/2/2016",
                         "17/2/2016", "13/3/2016", "6/4/2016",
                         "17/4/2016", "15/5/2016", "24/5/2016",
                         "2/6/2016", "12/6/2016", "17/7/2016",
                         "3/8/2016", "21/8/2016", "7/9/2016",
                         "18/9/2016", "23/10/2016", "23/11/2016",
                         "20/11/2016", "11/12/2016", "16/1/2017",
                         "15/2/2017"),
                       format = "%d/%m/%Y")
polls2017 <- tab %>%
    mutate(MidDate = StartDate + (EndDate - StartDate) / 2) %>%
    gather(Party, VotingIntention, -StartDate, -EndDate, -MidDate, -Poll, -WikipediaDates) %>%
    mutate(Poll = gsub("\\[.+\\]", "", Poll),
           VotingIntention = gsub("\\[.+\\]", "", VotingIntention),
           VotingIntention = as.numeric(VotingIntention) / 100) %>%
    arrange(MidDate)

library(ggplot2)
library(scales)
library(forcats)

polls2017 %>%
    mutate(Party = fct_reorder(Party, VotingIntention, .desc = TRUE),
           Poll = fct_relevel(Poll, "Election result")) %>%
    ggplot(aes(x = MidDate, y = VotingIntention, colour = Party, shape = Poll, linetype = Poll)) +
    geom_line(alpha = 0.5) +
    geom_point() +
    geom_smooth(aes(group = Party), se = FALSE, colour = "grey15") +
    scale_colour_manual(values = parties_v) +
    scale_y_continuous("Voting intention", label = percent) +
    facet_wrap(~Party, scales = "free_y") +
    theme_grey()

