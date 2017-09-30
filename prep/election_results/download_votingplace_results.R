# ./prep/download_votingplace_results.R
# Peter Ellis, April 2016

download_results <- function(origin = "http://www.electionresults.govt.nz/electionresults_2014/e9/csv/e9_part8_", 
                             destfolder = "downloads/elect2014/",
                             number_electorates = 71){
    #-----------candidate votes----------
    if(!dir.exists(destfolder)){
        dir.create(destfolder)
    }
    filenames <- paste0(destfolder, "cand_", 1:number_electorates, ".csv")
    
    for(i in 1:number_electorates){
        url <- paste0(origin, "cand_", i, ".csv")    
        download.file(url, destfile = filenames[i], quiet = TRUE)
    }
    
    #-------------party votes-----------
    filenames <- paste0(destfolder, "party_", 1:number_electorates, ".csv")
    
    for(i in 1:number_electorates){
        url <- paste0(origin, "party_", i, ".csv")    
        download.file(url, destfile = filenames[i], quiet = TRUE)
    }
    
    
}

# There were 71 electorates in 2014, 70 in 2011 and 2008, 69 in 2005
# https://en.wikipedia.org/wiki/New_Zealand_electorates

download_results("http://www.electionresults.govt.nz/electionresults_2014/e9/csv/e9_part8_",
                 "downloads/elect2014/",
                 number_electorates = 71)

download_results("http://www.electionresults.govt.nz/electionresults_2011/e9/csv/e9_part8_",
                 "downloads/elect2011/",
                 number_electorates = 70)

download_results("http://www.electionresults.govt.nz/electionresults_2008/e9/csv/e9_part8_",
                 "downloads/elect2008/",
                 number_electorates = 70)

download_results("http://www.electionresults.govt.nz/electionresults_2005/e9/csv/e9_part8_",
                 "downloads/elect2005/",
                 number_electorates = 69)

download_results("http://www.electionresults.govt.nz/electionresults_2002/e9/csv/e9_part8_",
                 "downloads/elect2002/",
                 number_electorates = 69)

#=================voting place locations==================
# these are only published from 2008 onwards

download.file(
    "http://www.electionresults.govt.nz/electionresults_2014/2014_Voting_Place_Co-ordinates.xls",    
    destfile = "downloads/elect2014/vp_coordinates.xls",
    mode = "wb"
)

download.file(
    "http://www.electionresults.govt.nz/electionresults_2011/2011_Polling_Place_Co-ordinates.xls",    
    destfile = "downloads/elect2011/vp_coordinates.xls",
    mode = "wb"
)

download.file(
    "http://www.electionresults.govt.nz/electionresults_2008/2008_Polling_Place_Co-ordinates.xls",    
    destfile = "downloads/elect2008/vp_coordinates.xls",
    mode = "wb"
)




