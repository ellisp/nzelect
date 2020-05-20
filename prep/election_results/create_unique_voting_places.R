# Now that we've found all the fuzzy duplicates and assigned unique IDs with find_voting_place_duplicates.R,
# we can use this to complete our ETL to the final data model

# This creates a dataset of just the distinct voting places - the voting place dimension table, if you like.
# We also go back to the nzge object and supplement all of its text locations with the IDs linking to that
# dimension table.  Then we can discard voting_places itself

#------------create the distinct voting places-------------------

# First, get those with point locations from voting_places
distinct_voting_places <- voting_places %>%
    group_by(voting_place_id) %>%
    arrange(desc(election_year)) %>%
    summarise(last_used_name = voting_place[1],
              latitude = mean(latitude),
              longitude = mean(longitude))


#----------------merge the voting_place_id onto nzge---------------
nzge <- nzge %>%
    left_join(distinct(voting_places[ , c("voting_place", "election_year", "voting_place_id")]), 
              by = c("voting_place", "election_year"))

# remove the voting_places object, which is by now rather complicated and prone to causing problems
# when anything joins to it
rm(voting_places)
