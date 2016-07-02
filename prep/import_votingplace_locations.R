# ./prep/import_votingplace_locations.R

# Downloads and imports voting place locations, cleans them up and matches
# to shapefiles of Regional Council, meshblock, etc
# Peter Ellis, April 2016

library(xlsx)
# I couldn't get the text encoding fo the csv or txt versions to work so have
# downloaded the Excel instead.

download.file("http://www.electionresults.govt.nz/electionresults_2014/2014_Voting_Place_Co-ordinates.xls",
              destfile = "downloads/elect2014/vp_coordinates.xls", mode = "wb")


# takes 2 minutes:
vpc_orig <- read.xlsx("downloads/elect2014/vp_coordinates.xls", sheetIndex = 1)

vpc <- vpc_orig %>%
    mutate(VotingPlace = gsub(" M..ori ", " Maori ", Voting.Place.Address),
           VotingPlace = gsub("Ng.+ Hau e Wh.+ o Papar.+rangi, 30 Ladbrooke Drive",
                              "Nga Hau e Wha o Papararangi, 30 Ladbrooke Drive",
                              VotingPlace)) %>%
    mutate(Electorate.Name = str_trim(Electorate.Name),
           Electorate.Name = gsub("^Te Atat.*$", "Te Atatu", Electorate.Name),
           Electorate.Name = gsub("^Rangit.*kei$", "Rangitikei", Electorate.Name),
           Electorate.Name = gsub("^T.*maki$", "Rangitikei", Electorate.Name))




vpa <- unique(vpc$VotingPlace)
vpv <- unique(GE2014$VotingPlace)
sum(!vpa %in% vpv) # 0 voting places not in the votes data
sum(!vpv %in% vpa) # 6 votes data places not in the list

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

save(Locations2014, file = "pkg/data/Locations2014.rda", compress = "xz")



