#./build.R
# Peter Ellis, April 2016
# Builds (from scratch if necessary for a fresh clone) the nzelect R package



#----------------functionality------------
library(knitr)
library(devtools)
library(xlsx)
library(stringr)
library(rgdal) # for map functionality
library(scales)
library(httr)
library(rvest)
library(stringr)
library(testthat)
library(tidyverse)
library(GGally)
library(gridExtra)
library(maps)
library(grid)
library(ggmap)
library(stringdist)
library(proj4)

build1 <- TRUE # whether to build nzelect
build2 <- FALSE  # whether to build nzcensus
#-------------downloads---------------
# These are one-offs, and separated from the rest of the grooming to avoid
# repeating expensive downloads

# About 5MB worth of voting results from 2002 to 2014:
# source("prep/election_results/download_votingplace_results.R")

# About 130MB of shapefiles / maps, used for locating voting places in areas:
# source("prep/census_related/download_map_shapefiles.R")

# source("prep/census_related/download_census2013.R")

# download.file("http://www.electionresults.govt.nz/electionresults_2014/2014_Voting_Place_Co-ordinates.xls",
#              destfile = "downloads/elect2014/vp_coordinates.xls", mode = "wb")

#----------tidying----------------
if(build1){
    # import all the voting results CVS and amalgamate into a single object
    source("prep/election_results/tidy_votingplace_results.R") # 30 seconds
    source("prep/election_results/tidy_votingplace_results_2017.R") # 30 seconds
    
    # download and import the actual locations.  Includes a 575KB download.
    # This script also calls several other scripts from within itself 
    # (takes a few minutes to run because of importing shapefiles, downloaded earlier):
    source("prep/election_results/import_votingplace_locations.R") # 3 minutes 
    
    source("prep/long_term_gdp_nz.R")
}
if(build2){
    # Import and tidy up census data
    source("prep/census_related/import_census.R") # 30 seconds
    
    # Match census data to shapefiles so we have lat and long
    source("prep/census_related/add_locations_census.R")

    # Create cartograms
    # go to "prep/census_related/create-cartograms.R" and run by hand; requires some manual steps with ScapeToad
}

#-------opinion polls and related-------------------
if(build1){
    # Load in the existing version of the polls to facilitate checking and seeing
    # if anything has gone wrong with the source material on Wikipedia
    load("pkg1/data/polls.rda")
    oldpolls <- polls
    rm(polls)
    
    source("prep/polls/download_polls_2005.R")
    source("prep/polls/download_polls_2008.R")
    source("prep/polls/download_polls_2011.R")
    source("prep/polls/download_polls_2014.R")
    source("prep/polls/download_polls_2017.R")
    source("prep/polls/download_polls_2020.R")
    source("prep/polls/combine_polls.R")
    
    expect_equal(oldpolls, polls[1:nrow(oldpolls), ])
    # polls_both <- cbind(oldpolls, polls[1:nrow(oldpolls), ])
    # names(polls_both)[1:ncol(polls)] <- paste0(names(oldpolls), "_old")
    # 
    # polls_both %>%    filter(Party_old != Party) %>% View
    # polls_both %>%    filter(Pollster_old != Pollster) %>% View
    # polls_both %>%    filter(WikipediaDates_old != WikipediaDates) %>% View
    # polls_both %>%    filter(VotingIntention_old != VotingIntention) %>% View
    # polls_both %>%    filter(VotingIntention_old != VotingIntention) %>% View
    
    # rm(oldpolls)
    
    # need some automated tests along the lines of checking this for validity:
    # View(unique(polls[ ,c("WikipediaDates", "MidDate")]))
}

#--------------build the actual packages---------
# create helpfiles:
if(build1) document("pkg1")
if(build2) document("pkg2")


# unit tests, including check against published totals
if(build1)test("pkg1")
if(build2)test("pkg2") # wrong number of cols in REGC2013...

# create README for GitHub repo:
knit("README.Rmd", "README.md")

# run CRAN checks
if(build1)check("pkg1") 
if(build2)check("pkg2") # one note from exceeding 5MB, and the cartograms need helpfiles

# create vignettes for actual builds
if(build1){
    build_vignettes("pkg1")
    unlink("pkg1/.gitignore")
}
if(build2)build_vignettes("pkg2") 



# run win-builder checks and email results to maintainer (Peter Ellis)
if(build1)check_win_devel("pkg1")
if(build2)check_win_devel("pkg2")


# create .tar.gz for CRAN or wherever
if(build1)build("pkg1")
if(build2)build("pkg2")

if(build1)system("Rcmd.exe INSTALL --no-multiarch --with-keep.source pkg1")
if(build2)system("Rcmd.exe INSTALL --no-multiarch --with-keep.source pkg2")

#-----------------shiny app----------------
# munge data for Shiny app and prompts to deploy it:
# if(build1)source("prep/shiny_prep.R")
# shiny::runApp("examples/leaflet")
