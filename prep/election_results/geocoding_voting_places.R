library(nzelect)

head(voting_places)

library(ggmap)
geocode(paste0(voting_places[1, "voting_place"], ", New Zealand"))
dim(voting_places)

rows <- list(1:2000, 2001:4000, 4001:6000, 6001:nrow(voting_places))
gg_locs <- list()

# next two lines executed 2 October 2017:
gg_locs[[1]] <- geocode(paste0(voting_places[rows[[1]], "voting_place"], ", New Zealand"))
save(gg_locs, file = "data/gg_locs.rda")



gg_locs[[2]] <- geocode(paste0(voting_places[rows[[2]], "voting_place"], ", New Zealand"))
save(gg_locs, file = "data/gg_locs.rda")

gg_locs[[3]] <- geocode(paste0(voting_places[rows[[3]], "voting_place"], ", New Zealand"))
save(gg_locs, file = "data/gg_locs.rda")

gg_locs[[4]] <- geocode(paste0(voting_places[rows[[4]], "voting_place"], ", New Zealand"))
save(gg_locs, file = "data/gg_locs.rda")

gg_locs_df <- do.call("rbind", gg_locs)