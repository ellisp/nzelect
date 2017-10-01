# ./prep/import_votingplace_locations.R

# Imports voting place locations, cleans them up and matches
# to shapefiles of Regional Council, meshblock, etc
# Peter Ellis, April 2016

# I couldn't get the text encoding fo the csv or txt versions to work so have
# downloaded the Excel instead.

# We have three elections worth of voting places, obviously nearly all of them duplicates
# takes 6 minutes:
vpc_orig_2014 <- read.xlsx("downloads/elect2014/vp_coordinates.xls", sheetIndex = 1, encoding = "UTF-8")
vpc_orig_2011 <- read.xlsx("downloads/elect2011/vp_coordinates.xls", sheetIndex = 1, encoding = "UTF-8")
vpc_orig_2008 <- read.xlsx("downloads/elect2008/vp_coordinates.xls", sheetIndex = 1, encoding = "UTF-8")


n <- names(vpc_orig_2014[ ,1:7])
names(vpc_orig_2011) <- n
names(vpc_orig_2008) <- n
vpc <- rbind(vpc_orig_2014[ ,1:7], vpc_orig_2011, vpc_orig_2008) %>%
    mutate(Electorate.Name = str_trim(Electorate.Name)) %>%
    mutate(voting_place = gsub(" M.ori ", " Maori ", Voting.Place.Address),
           voting_place = gsub("Ng.+ Hau e Wh.+ o Papar.+rangi, 30 Ladbrooke Drive",
                              "Nga Hau e Wha o Papararangi, 30 Ladbrooke Drive",
                              voting_place),
           voting_place = str_trim(voting_place))

vpc$election_year <- rep(c(2014, 2011, 2008), times = c(
    nrow(vpc_orig_2014),
    nrow(vpc_orig_2011),
    nrow(vpc_orig_2008)
))


vpa <- unique(vpc$voting_place)
vpv <- unique(nzge[nzge$election_year >= 2008, "voting_place"])

if(sum(!vpa %in% vpv) > 2){
    print(sort(vpa[!vpa %in% vpv]))
    stop("More than 2 voting place locations failed to match with voting place results")
}


if(sum(!vpv %in% vpa) > 72){
    # should be6 votes data places not in the list
    print(sort(vpv[!vpv %in% vpa]))
    stop("More than 72 voting place results failed to match to voting place locations")   
}

# voting places not in the locations:
message("Votes registered but no matching geography:")
print(vpv[!vpv %in% vpa])


voting_places <- vpc %>%
    select(-Voting.Place.Address) 

names(voting_places) <- gsub(".", "", names(voting_places), fixed = TRUE)

# Chatham Islands has wrong or coordinates in 2014 and 2011
voting_places <- voting_places %>%
    mutate(NZTM2000Northing = ifelse(VotingPlaceSuburb == "Chatham Islands", 395114, NZTM2000Northing),
           NZTM2000Easting = ifelse(VotingPlaceSuburb == "Chatham Islands", 805299, NZTM2000Easting))



# match to mesh blocks, regions, etc
source("./prep/election_results/match_locations_to_areas.R")

save(voting_places, file = "pkg1/data/voting_places.rda", compress = "xz")



