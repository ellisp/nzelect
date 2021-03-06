# ./prep/import_votingplace_locations.R

# Imports voting place locations, cleans them up and matches
# to shapefiles of Regional Council, meshblock, etc
# Peter Ellis, April 2016

# I couldn't get the text encoding fo the csv or txt versions to work so have
# downloaded the Excel instead.

# We have three elections worth of voting places, obviously nearly all of them duplicates
# takes 6 minutes:
vpc_orig_2017 <- read.csv("http://www.electionresults.govt.nz/electionresults_2017/statistics/csv/voting-place-coordinates.csv",
                          encoding = "UTF-8")
vpc_orig_2014 <- read.xlsx("downloads/elect2014/vp_coordinates.xls", sheetIndex = 1, encoding = "UTF-8")[ ,1:7]
vpc_orig_2011 <- read.xlsx("downloads/elect2011/vp_coordinates.xls", sheetIndex = 1, encoding = "UTF-8")
vpc_orig_2008 <- read.xlsx("downloads/elect2008/vp_coordinates.xls", sheetIndex = 1, encoding = "UTF-8")

vpc_2017 <- vpc_orig_2017
vpc_2014 <- vpc_orig_2014
vpc_2011 <- vpc_orig_2011
vpc_2008 <- vpc_orig_2008

#=============sort out names and mapping projections============
n <- names(vpc_2014[ ,1:7])

# need the first names to match (Pplling.Place.ID not Voting.Place.ID), but beware -
# the order of Northing and Easting (variables 6 and 7) changes from year to year.
names(vpc_2011) <- c(n[1:5], "easting", "northing")
names(vpc_2008) <- c(n[1:5], "easting", "northing")
names(vpc_2014) <- c(n[1:5], "northing", "easting")


# Coordinates to lat and long.  Note that 2008 is NZMG and 2011 in is NZTM2000
# See https://gis.stackexchange.com/questions/20389/converting-nzmg-or-nztm-to-latitude-longitude-for-use-with-r-map-library
nzmgp4s <- "+proj=nzmg +lat_0=-41 +lon_0=173 +x_0=2510000 +y_0=6023150 +ellps=intl +datum=nzgd49 +units=m +towgs84=59.47,-5.04,187.44,0.47,-0.1,1.024,-4.5993 +nadgrids=nzgd2kgrid0005.gsb +no_defs"
nztmp4s <- "+proj=tmerc +lat_0=0.0 +lon_0=173.0 +k=0.9996 +x_0=1600000.0 +y_0=10000000.0 +datum=WGS84 +units=m"

tmp <- rgdal::project(as.matrix(vpc_2008[6:7]), proj = nzmgp4s, inv = TRUE)
vpc_2008$longitude <- tmp[ , 1]
vpc_2008$latitude <- tmp[ , 2]

tmp <- rgdal::project(as.matrix(vpc_orig_2011[6:7]), proj = nztmp4s, inv = TRUE)
vpc_2011$longitude <- tmp[ , 1]
vpc_2011$latitude <- tmp[ , 2]

tmp <- rgdal::project(as.matrix(vpc_orig_2014[7:6]), proj = nztmp4s, inv = TRUE)
vpc_2014$longitude <- tmp[ , 1]
vpc_2014$latitude <- tmp[ , 2]

vpc_2017 <- vpc_2017 %>%
    dplyr::rename(latitude = WSG84.Latitude,
           longitude = WSG84.Longitude,
           easting = NZTM.Easting,
           northing = NZTM.Northing)

#-----------------check the voting places have votes and vice versa-----------
vpc <- rbind(vpc_2014, vpc_2011, vpc_2008) %>%
    select(-Voting.Place.ID) %>%
    mutate(Type = NA) %>%
    rbind(vpc_2017) %>%
    mutate(Electorate.Name = str_trim(Electorate.Name)) %>%
    mutate(voting_place = gsub(" M.ori ", " Maori ", Voting.Place.Address),
           voting_place = gsub("Ng.+ Hau e Wh.+ o Papar.+rangi, 30 Ladbrooke Drive",
                              "Nga Hau e Wha o Papararangi, 30 Ladbrooke Drive",
                              voting_place),
           voting_place = str_trim(voting_place))

vpc$election_year <- rep(c(2014, 2011, 2008, 2017), times = c(
    nrow(vpc_2014),
    nrow(vpc_2011),
    nrow(vpc_2008),
    nrow(vpc_2017)
))


vpa <- unique(vpc$voting_place)
vpv <- unique(nzge[nzge$election_year >= 2008, "voting_place"])

# From 2017 there are hundreds of extra non-point locations eg special votes etc
# The voting_place data really is quite moot.
# 
# if(sum(!vpa %in% vpv) > 2){
#     print(sort(vpa[!vpa %in% vpv]))
#     stop("More than 2 voting place locations failed to match with voting place results")
# }
# 
# 
# if(sum(!vpv %in% vpa) > 72){
#     # should be6 votes data places not in the list
#     print(sort(vpv[!vpv %in% vpa]))
#     stop("More than 72 voting place results failed to match to voting place locations")   
# }
# 
# # voting places not in the locations:
# message("Votes registered but no matching geography:")
# print(vpv[!vpv %in% vpa])


#-------------------compile the voting_places object------------
voting_places <- vpc %>%
    select(-Voting.Place.Address) %>%
    mutate(coordinate_system = ifelse(election_year <= 2008, "NZMG", "NZTM2000"))

names(voting_places) <- gsub(".", "", names(voting_places), fixed = TRUE)

# Chatham Islands has wrong or coordinates in 2014 and 2011
voting_places <- voting_places %>%
    mutate(longitude = ifelse(VotingPlaceSuburb == "Chatham Islands", 175.9, longitude),
           latitude = ifelse(VotingPlaceSuburb == "Chatham Islands", -44.0, latitude)) %>%
    rename(electorate_number = ElectorateNumber, electorate = ElectorateName,
           voting_place_suburb = VotingPlaceSuburb,
           type = Type)

#------------------------add in some missing ones--------
actually_missing <- nzge %>%
    as_tibble() %>%
    select(approx_location, voting_place, election_year) %>%
    filter(election_year >= 2008) %>%
    distinct() %>%
    anti_join(voting_places, by = c("voting_place" = "voting_place", 
                                    "election_year" = "election_year")) %>%
    filter(!grepl("votes", voting_place, ignore.case = TRUE),
           !grepl("Team", voting_place, ignore.case = TRUE),
           !grepl("Mobile", voting_place, ignore.case = TRUE)) %>%
    distinct() 


# we can find 10 of these 11 locations with Google's geo coding service
ggcodes <- geocode(paste(actually_missing$voting_place, 
                         actually_missing$approx_location,
                         "New Zealand",
                         sep= ", "),
                   source = "google")
# The missing one is a genuine non-point, Wiri Hospital, Rest Home and Prison - Taken in Maurewa
# One location is definitely wrong with longitude -89 and lat 31 even though it's definiteluy
# meant to be in Tauranga

voting_places <-  cbind(actually_missing, ggcodes) %>%
    filter(voting_place != "Hosptial, Rest Home and Prison - Taken in Murewa") %>%
    filter(lon > 0) %>%
    select(-approx_location) %>%
    rename(longitude = lon,
           latitude = lat) %>%
        mutate(electorate_number = NA, 
               electorate = NA,
               voting_place_suburb = NA,
               northing = NA,
               easting = NA,
               type = "Election Day",
               coordinate_system = NA) %>% 
    rbind(voting_places)

#--------------------remove duplicates and create unique IDs------------------
source("./prep/election_results/find_voting_place_duplicates.R")

source("./prep/election_results/create_unique_voting_places.R")


#-------------add the spatial area attributes-----------------------
# match to mesh blocks, regions, etc
source("./prep/election_results/match_locations_to_areas.R")


save(distinct_voting_places, file = "pkg1/data/distinct_voting_places.rda", compress = "xz")
save(nzge, file = "pkg1/data/nzge.rda", compress = "xz")



