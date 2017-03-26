#./build.R
# Peter Ellis, April 2016
# Builds (from scratch if necessary for a fresh clone) the nzelect R package

#----------------functionality------------
library(knitr)
library(devtools)
library(xlsx)
library(stringr)
library(rgdal) # for map functionality
library(tidyverse)
library(scales)
library(httr)
library(rvest)
library(stringr)
library(testthat)

#-------------downloads---------------
# These are one-offs, and separated from the rest of the grooming to avoid
# repeating expensive downloads

# About 1MB worth of voting results:
source("prep/download_votingplace_results.R")

# About 130MB of shapefiles / maps, used for locating voting places in areas:
source("prep/download_map_shapefiles.R")

source("prep/download_census2013.R")


#----------tidying----------------
# import all the voting results CVS and amalgamate into a single object
source("prep/tidy_votingplace_results.R") # 30 seconds

# download and import the actual locations.  Includes a 575KB download.
# This script also calls ./prep/match_locations_to_areas.R from within itself 
# (takes a few minutes to run because of importing shapefiles, downloaded earlier):
source("prep/import_votingplace_locations.R") # 3 minutes

# Import and tidy up census data
source("prep/import_census.R")

# Match census data to shapefiles so we have lat and long
source("prep/add_locations_census.R")

#-------opinion polls and related-------------------
load("pkg1/data/polls.rda")
oldpolls <- polls
rm(polls)

source("prep/download_polls_2005.R")
source("prep/download_polls_2008.R")
source("prep/download_polls_2011.R")
source("prep/download_polls_2014.R")
source("prep/download_polls_2017.R")
source("prep/combine_polls.R")

expect_equal(oldpolls, polls[1:nrow(oldpolls), ])

# any mismatches will be from edits to Wikipedia.  Check with variants of these:
# View(oldpolls[which(oldpolls$VotingIntention != polls$VotingIntention), ])
# View(oldpolls[which(oldpolls$VotingIntention != polls$VotingIntention), ])
# View(polls[which(oldpolls$VotingIntention != polls$VotingIntention), ])
# rm(oldpolls)

# need some automated tests along the lines of checking this for validity:
# View(unique(polls[ ,c("WikipediaDates", "MidDate")]))


#--------------build the actual package---------
# create helpfiles:
document("pkg1")
document("pkg2")


# unit tests, including check against published totals
test("pkg1")
test("pkg2") 

# create README for GitHub repo:
knit("README.Rmd", "README.md")

# run pedantic CRAN checks
check("pkg1") 
check("pkg2") # one note from exceeding 5MB

# create vignettes for actual builds
build_vignettes("pkg1") 
build_vignettes("pkg2") 



# run win-builder checks and email results to maintainer (Peter Ellis)
build_win("pkg1")
build_win("pkg2")


# create .tar.gz for CRAN or wherever
build("pkg1")
build("pkg2")

system("Rcmd.exe INSTALL --no-multiarch --with-keep.source pkg2")

#-----------------shiny app----------------
# munge data for Shiny app and prompts to deploy it:
source("prep/shiny_prep.R")

