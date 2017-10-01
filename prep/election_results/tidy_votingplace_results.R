# ./prep/tidy_votingplace_results.R
# imports previously downloaded CSVs of election results by voting place.
# So far only for 2014 General Election
# Peter Ellis, April 2016

#===================define a function================
tidy_results <- function(election_year = 2014, encoding = "UTF-8-BOM"){
    
    # where are the files and how many?
    origin <- paste0("downloads/elect", election_year, "/")
    number_electorates = length(list.files(origin)) / 2
    
    #---------------------candidate results-------------------
    filenames <- paste0(origin, "cand_", 1:number_electorates, ".csv")
    
    results_voting_place <- list()
    
    for (i in 1:number_electorates){
        
        # What is the electorate name?  Is in cell A2 of each csv
        electorate <- read.csv(filenames[i], skip=1, nrows=1, header=FALSE, 
                               stringsAsFactors=FALSE, fileEncoding = encoding)[,1]
        
        # read in the bulk of the data
        tmp <- tryCatch({
            read.csv(filenames[i], skip=2, check.names=FALSE, stringsAsFactors=FALSE, fileEncoding = encoding)
        }, warning = function(w) {
            ## do something about the warning, maybe return 'NA'
            # message(paste0("Got warnings with UTF-8-BOM encoding for file #", i, ", so trying without it"))
            tmp <- read.csv(filenames[i], skip=2, check.names=FALSE, stringsAsFactors=FALSE)    
        })

      
        # read in the candidate names and parties  
        first_blank <- which(tmp[,2] == "")
        candidates_parties <- tmp[(first_blank + 2) : nrow(tmp), 1:2]
        names(candidates_parties) <- c("candidate", "party")
        candidates_parties <- rbind(candidates_parties,
                                    data.frame(candidate="Informal Candidate Votes", party="Informal Candidate Votes"))
        
        # we knock out all the rows from (first_blank - 1) (which is the total)
        tmp <- tmp[-((first_blank - 1) : nrow(tmp)), ]
        names(tmp)[1:2] <- c("approx_location", "voting_place")
        
        # in some of the data there are annoying subheadings in the second column.  We can
        # identify these as rows that return NA when you sum up where the votes should be
        tmp <- tmp[!is.na(apply(tmp[, -(1:2)], 1, function(x){sum(as.numeric(x))})), ]
        
        # need to fill in the gaps where there is no polling location
        last_approx_location <- tmp[1, 1]
        for(j in 1: nrow(tmp)){
            if(tmp[j, 1] == "") {
                tmp[j, 1] <- last_approx_location
            } else {
                last_approx_location <- tmp[j, 1]
            }
        }  
        
        # normalise / tidy
        tmp <- tmp[names(tmp) != "Total Valid Candidate Votes"] %>%
            gather(candidate, votes, -approx_location, -voting_place)
        
        tmp$Electorate <- electorate
        tmp <- tmp %>%
            left_join(candidates_parties, by = "candidate")
        results_voting_place[[i]] <- tmp
    }
    
    # combine all electorates
    candidate_results_voting_place <- do.call("rbind", results_voting_place) %>%
        mutate(votes = as.numeric(votes),
               party = gsub("M..ori Party", "Maori Party", party),
               voting_type = "Candidate")
    
    #-------------------party votes--------------------
    filenames <- paste0(origin, "party_", 1:number_electorates, ".csv")
    
    results_voting_place <- list()
    
    for (i in 1:number_electorates){
        
        # What is the electorate name?  Is in cell A2 of each csv
        electorate <- read.csv(filenames[i], skip=1, nrows=1, header=FALSE, 
                               stringsAsFactors=FALSE, fileEncoding = "UTF-8-BOM")[,1]
        
        # read in the bulk of the data
        tmp <- tryCatch({
            read.csv(filenames[i], skip=2, check.names=FALSE, stringsAsFactors=FALSE, fileEncoding = encoding)
        }, warning = function(w) {
            ## do something about the warning, maybe return 'NA'
            # message(paste0("Got warnings with UTF-8-BOM encoding for file #", i, ", so trying without it"))
            tmp <- read.csv(filenames[i], skip=2, check.names=FALSE, stringsAsFactors=FALSE)    
        })
        
        first_blank <- which(tmp[, 2] == "")[1]
        
        # we knock out all the rows from (first_blank - 1) (which is the total)
        tmp <- tmp[-((first_blank - 1) : nrow(tmp)), ]
        names(tmp)[1:2] <- c("approx_location", "voting_place")
        
        # in some of the data there are annoying subheadings in the second column.  We can
        # identify these as rows that return NA when you sum up where the votes should be
        tmp <- tmp[!is.na(apply(tmp[, -(1:2)], 1, function(x){sum(as.numeric(x))})), ]
        
        # need to fill in the gaps where there is no polling location
        last_approx_location <- tmp[1, 1]
        for(j in 1: nrow(tmp)){
            if(tmp[j, 1] == "") {
                tmp[j, 1] <- last_approx_location
            } else {
                last_approx_location <- tmp[j, 1]
            }
        }  
        
        tmp <- tmp[names(tmp) != "Total Valid Party Votes"] %>%
            gather(party, votes, -approx_location, -voting_place)
        
        tmp$Electorate <- electorate
        results_voting_place[[i]] <- tmp
    }
    
    party_results_voting_place <- do.call("rbind", results_voting_place) %>%
        mutate(votes = as.numeric(votes),
               party = gsub("M..ori Party", "Maori Party", party),
               voting_type = "Party")
    
    #---------------combine the party and candidate voting place results--------------
    combined <- party_results_voting_place %>%
        mutate(candidate = NA) %>%
        rbind(candidate_results_voting_place)  %>%
        mutate(voting_place = str_trim(voting_place),
               approx_location = str_trim(approx_location),
               candidate = str_trim(candidate),
               election_year = election_year)
    
    names(combined) <- tolower(names(combined))
    
    return(combined)
    
}

#==============execute for the various years===============

results <- lapply(c(2002, 2005, 2008, 2011, 2014), tidy_results)
nzge <- do.call("rbind", results)

save("nzge", file = "pkg1/data/nzge.rda", compress = "xz")
