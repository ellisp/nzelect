#./build.R
# Peter Ellis, April 2016
# Builds (from scratch if necessary for a fresh clone) the nzelect R package

#----------------functionality------------
library(knitr)
library(devtools)

#-------------downloads---------------
# These are one-offs, and separated from the rest of the grooming to avoid
# repeating expensive downloads

# About 1MB worth of voting results:
source("prep/download_votingplace_results.R")

# About 130MB of shapefiles / maps, used for locating voting places in areas:
source("prep/download_map_shapefiles.R")


#----------tidying----------------
# import all the voting results CVS and amalgamate into a single object
source("prep/tidy_votingplace_results.R") # 30 seconds

# download and import the actual locations.  Includes a 575KB download.
# This script also calls ./prep/match_locations_to_areas.R from within itself 
# (takes a few minutes to run because of importing shapefiles, downloaded earlier):
source("prep/import_votingplace_locations.R") # 3 minutes

# Down the track there might be some import of economic and sociodemographic
# data here; currently only in development

# munge data for Shiny app and prompts to deploy it:
source("prep/shiny_prep.R")

#--------------build the actual package---------
# create helpfiles:
document("pkg")

# create README for GitHub repo:
knit("README.Rmd", "README.md")

# create .tar.gz for CRAN or wherever
build("pkg")
