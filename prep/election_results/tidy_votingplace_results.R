# ./prep/tidy_votingplace_results.R
# imports previously downloaded CSVs of election results by voting place.
# So far only for 2014 General Election
# Peter Ellis, April 2016

library(tidyr)
library(dplyr)
library(stringr)

#==================2014======================================
number_electorates <- 71

#---------------------2014 candidate results-------------------
filenames <- paste0("downloads/elect2014/e9_part8_cand_", 1:number_electorates, ".csv")

results_voting_place <- list()

for (i in 1:number_electorates){
    
    # What is the electorate name?  Is in cell A2 of each csv
    electorate <- read.csv(filenames[i], skip=1, nrows=1, header=FALSE, 
                           stringsAsFactors=FALSE, fileEncoding = "UTF-8-BOM")[,1]
    
    # read in the bulk of the data
    tmp <- read.csv(filenames[i], skip=2, check.names=FALSE, 
                    stringsAsFactors=FALSE, fileEncoding = "UTF-8-BOM")
  
    # read in the candidate names and parties  
    first_blank <- which(tmp[,2] == "")
    candidates_parties <- tmp[(first_blank + 2) : nrow(tmp), 1:2]
    names(candidates_parties) <- c("Candidate", "Party")
    candidates_parties <- rbind(candidates_parties,
                                data.frame(Candidate="Informal Candidate Votes", Party="Informal Candidate Votes"))
    
    # we knock out all the rows from (first_blank - 1) (which is the total)
    tmp <- tmp[-((first_blank - 1) : nrow(tmp)), ]
    names(tmp)[1:2] <- c("ApproxLocation", "VotingPlace")
    
    # in some of the data there are annoying subheadings in the second column.  We can
    # identify these as rows that return NA when you sum up where the votes should be
    tmp <- tmp[!is.na(apply(tmp[, -(1:2)], 1, function(x){sum(as.numeric(x))})), ]
    
    # need to fill in the gaps where there is no polling location
    last_ApproxLocation <- tmp[1, 1]
    for(j in 1: nrow(tmp)){
        if(tmp[j, 1] == "") {
            tmp[j, 1] <- last_ApproxLocation
        } else {
            last_ApproxLocation <- tmp[j, 1]
        }
    }  
    
    # normalise / tidy
    tmp <- tmp[names(tmp) != "Total Valid Candidate Votes"] %>%
        gather(Candidate, Votes, -ApproxLocation, -VotingPlace)
    
    tmp$Electorate <- electorate
    tmp <- tmp %>%
        left_join(candidates_parties, by = "Candidate")
    results_voting_place[[i]] <- tmp
}

# combine all electorates
candidate_results_voting_place <- do.call("rbind", results_voting_place) %>%
    mutate(Votes = as.numeric(Votes),
           Party = gsub("M..ori Party", "Maori Party", Party),
           VotingType = "Candidate")

#-------------------2014 party votes--------------------
filenames <- paste0("downloads/elect2014/e9_part8_party_", 1:number_electorates, ".csv")

results_voting_place <- list()

for (i in 1:number_electorates){
    
    # What is the electorate name?  Is in cell A2 of each csv
    electorate <- read.csv(filenames[i], skip=1, nrows=1, header=FALSE, 
                           stringsAsFactors=FALSE, fileEncoding = "UTF-8-BOM")[,1]
    
    # read in the bulk of the data
    tmp <- read.csv(filenames[i], skip=2, check.names=FALSE, 
                    stringsAsFactors=FALSE, fileEncoding = "UTF-8-BOM")
    
    first_blank <- which(tmp[, 2] == "")[1]
    
    # we knock out all the rows from (first_blank - 1) (which is the total)
    tmp <- tmp[-((first_blank - 1) : nrow(tmp)), ]
    names(tmp)[1:2] <- c("ApproxLocation", "VotingPlace")
    
    # in some of the data there are annoying subheadings in the second column.  We can
    # identify these as rows that return NA when you sum up where the votes should be
    tmp <- tmp[!is.na(apply(tmp[, -(1:2)], 1, function(x){sum(as.numeric(x))})), ]
    
    # need to fill in the gaps where there is no polling location
    last_ApproxLocation <- tmp[1, 1]
    for(j in 1: nrow(tmp)){
        if(tmp[j, 1] == "") {
            tmp[j, 1] <- last_ApproxLocation
        } else {
            last_ApproxLocation <- tmp[j, 1]
        }
    }  
    
    tmp <- tmp[names(tmp) != "Total Valid Party Votes"] %>%
        gather(Party, Votes, -ApproxLocation, -VotingPlace)
    
    tmp$Electorate <- electorate
    results_voting_place[[i]] <- tmp
}

party_results_voting_place <- do.call("rbind", results_voting_place) %>%
    mutate(Votes = as.numeric(Votes),
           Party = gsub("M..ori Party", "Maori Party", Party),
           VotingType = "Party")

#---------------combine the 2014 voting place results--------------
GE2014 <- party_results_voting_place %>%
    mutate(Candidate = NA) %>%
    rbind(candidate_results_voting_place)  %>%
    mutate(VotingPlace = str_trim(VotingPlace),
           ApproxLocation = str_trim(ApproxLocation),
           Candidate = str_trim(Candidate))

save(GE2014, file = "pkg1/data/GE2014.rda", compress = "xz")
