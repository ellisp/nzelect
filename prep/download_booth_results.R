#--------- Download 70 csvs for candidate vote------------------
number_electorates <- 70
filenames_cand <- paste0("raw_data/e9_part8_cand_", 1:number_electorates, ".csv")

for (i in 1:number_electorates){
    download.file(paste0("http://www.electionresults.govt.nz/electionresults_2011/e9/csv/e9_part8_cand_", i, ".csv"), 
                  filenames_cand[i], quiet=TRUE)
}
