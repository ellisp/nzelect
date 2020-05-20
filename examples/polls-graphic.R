library(nzelect)
library(tidyverse)
library(scales)
library(extrafont)

png("p:/R/ellisp/polls.png", 6000, 4500, res = 600)
polls %>%
    filter(!Party %in% c("Destiny", "Progressive")) %>%
    mutate(Party = gsub("M.ori", "Maori", Party)) %>%
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
    theme_light(base_family = "Comic Sans MS") +
    ggtitle("15 years of voting intention opinion polls in New Zealand") +
    labs(caption = "Source: nzelect #Rstats package on CRAN")
dev.off()
