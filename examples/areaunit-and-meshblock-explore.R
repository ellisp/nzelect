library(nzelect)
library(MASS) # for rlm()
library(dplyr)
library(tidyr)
head(GE2014)


head(Locations2014)

mbcount <- as.numeric(table(unique(Locations2014[, c("VotingPlace", "MB2014")])$MB2014))
table(mbcount) # 18 meshblocks have 2 voting places

aucount <- as.numeric(table(unique(Locations2014[, c("VotingPlace", "AU2014")])$AU2014))
table(aucount) # 406 meshblocks have 2 voting places, 10 have 7 and one even has 10


head(Locations2014)
head(Meshblocks2013)

mb <- GE2014 %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    left_join(Meshblocks2013, by = c("MB2014" = "MB"))

str(mb)
str(Locations2014)
summary(mb)
sum(is.na(mb$MB2014))
sum(is.na(mb$WGS84Longitude))
head(mb)

# 7 locations eg special votes with no meshblock:
unique(filter(mb, is.na(MB2014))$VotingPlace)

ggplot(Meshblocks2013, aes(x = PropBachelor2013, y = PropDoctorate2013)) +
    geom_point()

names(mb)

# note - quite important to use rlm() in the lines of best fit here for
# robust regression as otherwise outliers are too influential
GE2014 %>%
    filter(VotingType == "Party" &
               Party %in% c("Green Party", "Labour Party")) %>%
    group_by(VotingPlace) %>%
    summarise(PropGreens = sum(Votes[Party == "Green Party"]) / sum(Votes)) %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    left_join(Meshblocks2013, by = c("MB2014" = "MB")) %>%
    dplyr::select(PropGreens, MeanBedrooms2013:PropStudentAllowance2013) %>%
    gather(Variable, Value, -PropGreens) %>%
    mutate(Variable = gsub("2013", "", Variable),
           Variable = gsub("Prop", "Prop ", Variable)) %>%
    ggplot(aes(x = Value, y = PropGreens)) +
    facet_wrap(~Variable, scales = "free_x") +
    geom_point() +
    geom_smooth(method = "rlm", se = FALSE) +
    scale_y_continuous("Percentage of Labour and Green voters who voted Green Party in party vote", 
                       label = percent) +
    scale_x_continuous("note: horizontal scales vary; and some proportions exceed 1.0 due to confidentialising\nBlue lines are outlier-resistant robust regressions",
                       label = comma) +
    ggtitle("Choosing between Labour and Green in the 2014 New Zealand General Election\nEach point represents an individual voting location (vertical axis) and the meshblock within which it is located (horizontal axis)") + 
    theme(panel.margin = unit(1.5, "lines"))
    

GE2014 %>%
    filter(VotingType == "Party") %>%
    group_by(VotingPlace) %>%
    summarise(PropGreens = sum(Votes[Party == "National Party"]) / sum(Votes)) %>%
    left_join(Locations2014, by = "VotingPlace") %>%
    left_join(Meshblocks2013, by = c("MB2014" = "MB")) %>%
    dplyr::select(PropGreens, MeanBedrooms2013:PropStudentAllowance2013) %>%
    gather(Variable, Value, -PropGreens) %>%
    mutate(Variable = gsub("2013", "", Variable),
           Variable = gsub("Prop", "Prop ", Variable)) %>%
    ggplot(aes(x = Value, y = PropGreens)) +
    facet_wrap(~Variable, scales = "free_x") +
    geom_point() +
    geom_smooth(method = "rlm", se = FALSE) +
    scale_y_continuous("Percentage of party votes for National Party", 
                       label = percent) +
    scale_x_continuous("note: horizontal scales vary; and some proportions exceed 1.0 due to confidentialising\nBlue lines are outlier-resistant robust regressions",
                       label = comma) +
    ggtitle("Choosing the National Party in the 2014 New Zealand General Election\nEach point represents an individual voting location (vertical axis) and the meshblock within which it is located (horizontal axis)") + 
    theme(panel.margin = unit(1.5, "lines"))

    

