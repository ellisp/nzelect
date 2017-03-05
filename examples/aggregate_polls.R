library(nzelect)
library(tidyverse)
head(polls)

polls %>%
    filter(MidDate > "2014-12-30" & MidDate < "2017-1-1") %>%
    mutate(wt_p = weight_polls(MidDate, method = "pundit"),
           wt_c = weight_polls(MidDate, method = "curia", ref = as.Date("2016-12-26"))) %>%
    group_by(Party) %>%
    summarise(pundit = round(sum(VotingIntention * wt_p, na.rm = TRUE) / sum(wt_p) * 100, 1),
              curia = round(sum(VotingIntention * wt_c, na.rm = TRUE) / sum(wt_c) * 100, 1),
              unweighted = round(mean(VotingIntention, na.rm = TRUE) * 100, 1)) %>%
    filter(pundit > 0)


            