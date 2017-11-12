# This script creates a unique ID for voting places that are exactly or nearly exactly
# with the same name and or location.


#-------------set up---------------------

# there are some locations with exact name, same election year, but different
# lat and long! Must be listed twice in the Electoral Commission

vp2017 <- voting_places %>%
    filter(election_year == 2017) %>%
    select(voting_place, latitude, longitude)

so_far_unique <- vp2017 %>%
    select(voting_place) %>%
    distinct() %>%
    mutate(voting_place_id = 1:n()) %>%
    left_join(vp2017, by = "voting_place") %>%
    group_by(voting_place, voting_place_id) %>%
    summarise(latitude = mean(latitude),
              longitude = mean(longitude)) %>%
    ungroup()

latest_voting_places <- voting_places %>%
    left_join(so_far_unique[  , c("voting_place", "voting_place_id")], by = "voting_place")


all_years <- c(2014, 2011, 2008)

#------------------loop starts here-------------------
for(the_year in all_years){

    
    # data.frame of the new set of voting places (going backwards in time)
    # that are candidates for matching to places that already have an ID
    candidates <- voting_places %>%
        filter(election_year == the_year) %>%
        select(voting_place, latitude, longitude)
    
    # define a grid of all the pairwise comparisons of our candidates to existing places
    # that already have an ID
    vpg <- expand.grid(so_far_unique$voting_place, 
                       candidates$voting_place) %>%
        as_tibble() %>%
        left_join(so_far_unique, by = c("Var1" = "voting_place")) %>%
        rename(latitude1 = latitude, longitude1 = longitude) %>%
        left_join(candidates, by = c("Var2" = "voting_place")) %>%
        rename(latitude2 = latitude, longitude2 = longitude)  
    
    # work out how distant the places' names are (zero means identical)
    # stringdist is impressively fast and uses all available cores
    vpg$string_dist <- stringdist(vpg$Var1, vpg$Var2)
    
    # how far are they in spatial terms (ignoring curvature of Earth for our rough purposes)
    vpg <- vpg %>%
        mutate(ground_dist = sqrt((latitude1 - latitude2) ^ 2 + (longitude1 - longitude2) ^ 2))
    
    # even some places with only one ot two character different are different places eg
    # Garage, 47 Kaikoura Street versus Garage, 15 Kaikoura Street
    # So best to go with physical space
    # But what about Mt Maunganui Intermediate School 21 Lodge Avenue versus 
    # Mt Maunganui Intermediate School 21 Links Avenue? ()
    # And Banks Avenue School Library, 71 Banks Avenue versus Banks Avenue School, 71 Banks Avenue? (5e-04 apart)
    # From visual inspection, and looking some things up on a map, 0.002 is about 
    # the physical distance that seems to be the cut-off point
    
    matches <- vpg %>%
        group_by(Var2) %>%
        mutate(best = string_dist * ground_dist == min(string_dist * ground_dist)) %>%
        filter(best) %>%
        filter(string_dist == 0 | ground_dist < 0.002)
    
    expect_equal(length(unique(matches$Var2)), nrow(matches))
    
    # join our fuzzy matches back to the latest_voting_places so we get their ID numbers
    latest_voting_places <- latest_voting_places %>%
        left_join(matches[ , c("Var2", "voting_place_id")], by = c("voting_place" = "Var2")) %>%
        mutate(voting_place_id = ifelse(is.na(voting_place_id.y), voting_place_id.x, voting_place_id.y)) %>%
        select(-voting_place_id.x, -voting_place_id.y) 
    
    # At this point, we have matched everything to 2017 voting place IDs.  Now we need to add
    # to our unique ids so far all those that *didn't* get a match
    so_far_unique  <- latest_voting_places %>%
        filter(election_year == the_year & is.na(voting_place_id)) %>%
        select(voting_place, latitude, longitude) %>%
        ungroup() %>%
        mutate(voting_place_id = 1:n() + max(so_far_unique$voting_place_id)) %>%
        rbind(so_far_unique)

}

# one last join - for all the remaining places in the earliest year (ie the last one we looked at) that didn't
# get a match
latest_voting_places <- latest_voting_places %>%
    left_join(so_far_unique[ , c("voting_place", "voting_place_id")], by = "voting_place") %>%
    mutate(voting_place_id = ifelse(is.na(voting_place_id.y), voting_place_id.x, voting_place_id.y)) %>%
    select(-voting_place_id.x, -voting_place_id.y)

voting_places <- latest_voting_places
