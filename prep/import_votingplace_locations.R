# ./prep/import_votingplace_locations.R

# Imports voting place locations, cleans them up and matches
# to shapefiles of Regional Council, meshblock, etc
# Peter Ellis, April 2016

library(xlsx)
# I couldn't get the text encoding fo the csv or txt versions to work so have
# downloaded the Excel instead.

# takes 2 minutes:
vpc_orig <- read.xlsx("downloads/elect2014/vp_coordinates.xls", sheetIndex = 1, encoding = "UTF-8")

vpc <- vpc_orig %>%
    mutate(Electorate.Name = str_trim(Electorate.Name)) %>%
    mutate(VotingPlace = gsub(" M.ori ", " Maori ", Voting.Place.Address),
           VotingPlace = gsub("Ng.+ Hau e Wh.+ o Papar.+rangi, 30 Ladbrooke Drive",
                              "Nga Hau e Wha o Papararangi, 30 Ladbrooke Drive",
                              VotingPlace))

vpa <- unique(vpc$VotingPlace)
vpv <- unique(GE2014$VotingPlace)

if(sum(!vpa %in% vpv) > 0){
    print(vpa[!vpa %in% vpv])
    stop("Some voting place locations failed to match with voting place results")
}

if(sum(!vpv %in% vpa) > 6){
    # should be6 votes data places not in the list
    print(vpv[!vpv %in% vpa])
    stop("More than six voting place results failed to match to voting place locations")   
}

# voting places not in the locations:
message("Votes registered but no matching geography:")
print(vpv[!vpv %in% vpa])

# locations not in the voting places
if(sum(!vpa %in% vpv) != 0){
    print(vpa[!vpa %in% vpv])
    stop("Some voting locations didn't have any votes.")
}

Locations2014 <- vpc %>%
    select(-Voting.Place.Address) 
names(Locations2014) <- gsub(".", "", names(Locations2014), fixed = TRUE)

# match to mesh blocks, regions, etc
source("./prep/match_locations_to_areas.R")

save(Locations2014, file = "pkg1/data/Locations2014.rda", compress = "xz")



