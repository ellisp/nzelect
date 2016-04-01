

#==============================2014============================
#--------------------2014 candidate vote----------------------
# These draw from this location:
# http://www.electionresults.govt.nz/electionresults_2014/e9/html/e9_part8_cand_index.html
# The data are in CSVs with numbering


number_electorates <- 71
filenames <- paste0("downloads/elect2014/e9_part8_cand_", 1:number_electorates, ".csv")

for(i in 1:number_electorates){
    url <- paste0("http://www.electionresults.govt.nz/electionresults_2014/e9/csv/e9_part8_cand_", 
                  i, ".csv")    
    download.file(url, destfile = filenames[i], quiet = TRUE)
}


#---------------------2014 party vote-------------
filenames <- paste0("downloads/elect2014/e9_part8_party_", 1:number_electorates, ".csv")

for(i in 1:number_electorates){
    url <- paste0("http://www.electionresults.govt.nz/electionresults_2014/e9/csv/e9_part8_party_", 
                  i, ".csv")    
    download.file(url, destfile = filenames[i], quiet = TRUE)
}




#===============2011==========
#    "http://www.electionresults.govt.nz/electionresults_2011/e9/csv/e9_part8_cand_", 