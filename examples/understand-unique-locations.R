nzge %>%
    as_tibble() %>%
    filter(voting_type == "Party") %>%
    left_join(voting_places, by = c("election_year", "voting_place", "electorate")) %>%
    select(election_year, voting_place_id) %>%
    distinct() %>%
    group_by(voting_place_id) %>%
    summarise(times_used = n()) %>%
    arrange(desc(times_used)) %>%
    group_by(times_used) %>%
    summarise(freq = n())
    


nzge %>%
    as_tibble() %>%
    filter(voting_type == "Party") %>%
    left_join(voting_places, by = c("election_year", "voting_place", "electorate")) %>%
    select(election_year, voting_place_id) %>%
    distinct() %>%
    group_by(voting_place_id) %>%
    summarise(times_used = n()) %>%
    left_join(unique_voting_places, by = "voting_place_id") %>%
    arrange(desc(times_used)) %>%
    # select(times_used, last_used_name) %>%
    slice(1:10)
