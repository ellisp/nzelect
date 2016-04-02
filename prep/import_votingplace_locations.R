library(xlsx)
# I couldn't get the text encoding fo the csv or txt versions to work so have
# downloaded the Excel instead (yuck)

download.file("http://www.electionresults.govt.nz/electionresults_2014/2014_Voting_Place_Co-ordinates.xls",
              destfile = "downloads/elect2014/vp_coordinates.xls", mode = "wb")


# takes 2 minutes:
vpc_orig <- read.xlsx("downloads/elect2014/vp_coordinates.xls", sheetIndex = 1)

vpc <- vpc_orig %>%
    mutate(VotingPlace = gsub(" M..ori ", " Maori ", Voting.Place.Address),
           VotingPlace = gsub("NgÄ Hau e WhÄ o PaparÄrangi, 30 Ladbrooke Drive",
                              "Nga Hau e Wha o Papararangi, 30 Ladbrooke Drive",
                              VotingPlace))

vpa <- unique(vpc$VotingPlace)
vpv <- unique(GE2014$VotingPlace)
sum(!vpa %in% vpv) # 15 voting places not in the votes data
sum(!vpv %in% vpa) # 21 votes data places not in the list

# voting places not in the locations:
message("Votes registered but no matching geography:")
print(vpv[!vpv %in% vpa])

# locations not in the voting places
if(sum(!vpa %in% vpv) != 0){
    stop("Some voting locations didn't have any votes.")
}

head(vpc)

Locations2014 <- vpc %>%
    select(-Voting.Place.Address) 
names(Locations2014) <- gsub(".", "", names(Locations2014), fixed = TRUE)
head(Locations2014)

save(Locations2014, file = "pkg/data/Locations2014.rda", compress = "xz")



