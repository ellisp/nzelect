library(nzelect)
library(tidyverse)
head(polls)

# electorate seats for Act, Cons, Green, Labour, Mana, Maori, National, NZFirst, United,
# assuming that electorates stay as currently allocated.  This is critical particularly
# for ACT, Maori and United Future, who if they lose their single electorate seat each
# will not be represented in parliament
electorates <- c(1,0,0,27,0,1,41,1,1)

polls %>%
    filter(MidDate > "2014-12-30" & MidDate < "2017-1-1") %>%
    mutate(wt_p = weight_polls(MidDate, method = "pundit"),
           wt_c = weight_polls(MidDate, method = "curia", ref = as.Date("2016-12-26"))) %>%
    group_by(Party) %>%
    summarise(pundit = round(sum(VotingIntention * wt_p, na.rm = TRUE) / sum(wt_p) * 100, 1),
              curia = round(sum(VotingIntention * wt_c, na.rm = TRUE) / sum(wt_c) * 100, 1)) %>%
    ungroup() %>%
    filter(pundit > 0) %>%
    mutate(pundit_seats = allocate_seats(pundit, electorate = electorates)$seats_v,
           curia_seats = allocate_seats(curia, electorate = electorates)$seats_v)



            