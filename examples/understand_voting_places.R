head(voting_places)

voting_places %>%
    group_by(election_year) %>%
    summarise(man = max(northing),
              min = min(northing),
              mae = max(easting),
              mie = min(easting))


voting_places %>%
    group_by(election_year) %>%
    summarise(man = max(latitude),
              min = min(latitude),
              mae = max(longitude),
              mie = min(longitude))

# map of all the voting_places in the past four years
ggplot(voting_places, aes(x = longitude, y = latitude)) +
    geom_point() +
    facet_wrap(~election_year) +
    coord_map() 
    
head(voting_places)

voting_places %>%
    as_tibble() %>%
    filter(is.null(northing))

voting_places %>%
    select(voting_place) %>%
    distinct() %>%
    arrange(voting_place) %>%
    View()

# some of the early voting_places are not very specific eg "School".  
# Definitely need to be combined with the approxlocation
head(nzge$voting_place)

# 8046 locations with no match in voting_places
nzge %>%
    as_tibble() %>%
    select(approx_location, voting_place, election_year) %>%
    distinct() %>%
    anti_join(voting_places, by = c("voting_place" = "voting_place", 
                                    "election_year" = "election_year"))

#1685 "locations" with no match in voting_places in 2008 and later
nzge %>%
    as_tibble() %>%
    select(approx_location, voting_place, election_year) %>%
    filter(election_year >= 2008) %>%
    distinct() %>%
    anti_join(voting_places, by = c("voting_place" = "voting_place", 
                                    "election_year" = "election_year")) 

# but only 465 actual names - many are generic, genuine non-locations like 
# "Overseas Special Votes including defence force" or 
nzge %>%
    as_tibble() %>%
    select(approx_location, voting_place, election_year) %>%
    filter(election_year >= 2008) %>%
    distinct() %>%
    anti_join(voting_places, by = c("voting_place" = "voting_place", 
                                    "election_year" = "election_year")) %>%
    select(voting_place) %>%
    distinct()

# so we are down to 109 voting_places without "Votes" in their name.
# A lot of these still aren't genuine point locations but broader like
# "Hospital & Rest Homes Team - Taken in Botany" and "Movile AVT 1 -
# Hospitals, Rest Homes, RNZAF Base - Blenheim & Picton"
nzge %>%
    as_tibble() %>%
    select(approx_location, voting_place, election_year) %>%
    filter(election_year >= 2008) %>%
    distinct() %>%
    anti_join(voting_places, by = c("voting_place" = "voting_place", 
                                    "election_year" = "election_year")) %>%
    select(voting_place, election_year) %>%
    filter(!grepl("votes", voting_place, ignore.case = TRUE)) %>%
    distinct() 


# If we knock even those out we get down to just 11 actuall missing locations
actually_missing <- nzge %>%
    as_tibble() %>%
    select(approx_location, voting_place, election_year) %>%
    filter(election_year >= 2008) %>%
    distinct() %>%
    anti_join(voting_places, by = c("voting_place" = "voting_place", 
                                    "election_year" = "election_year")) %>%
    select(approx_location, voting_place, election_year) %>%
    filter(!grepl("votes", voting_place, ignore.case = TRUE),
           !grepl("Team", voting_place, ignore.case = TRUE),
           !grepl("Mobile", voting_place, ignore.case = TRUE)) %>%
    distinct() 


# we can find 10 of these 11 locations with Google's geo coding service
library(ggmap)
ggcodes <- geocode(paste(actually_missing$voting_place, 
                         actually_missing$approx_location,
                         "New Zealand",
                         sep= ", "),
                   source = "google")
# The missing one is a genuine non-point, Wiri Hospital, Rest Home and Prison - Taken in Maurewa
# One location is definitely wrong with longitude -89 and lat 31 even though it's definiteluy
# meant to be in Tauranga

cbind(actually_missing, ggcodes)
# ok, will add this to the import_votingplace_locations script
