# ./prep/match_locations_to_areas.R
# Peter Ellis, April 2016

# depends on the shapefiles having already been downloaded from
# ./prep/download_map_shapefiles.R; and Locations2014 to have
# been created via .prep/import_votingplace_locations.R
# This script then matches those point locations with the polygons
# of Regional Councils, Territorial Authority, and Area Unit.

# This script is called from ./prep/import_votingplace_locations.R




nztmp4s <- "+proj=tmerc +lat_0=0.0 +lon_0=173.0 +k=0.9996 +x_0=1600000.0 +y_0=10000000.0 +datum=WGS84 +units=m"

#-------------Import Territorial Authority map------------------
TA <- readOGR("downloads/shapefiles/2014 Digital Boundaries Generlised Clipped",
              "TA2014_GV_Clipped")

#------------------convert locations to sp format-----------
# first, project them back to NZTM2000 so they are the same as the maps
locs_nztm <- rgdal::project(as.matrix(distinct_voting_places[, c("longitude", "latitude")]), proj = nztmp4s, inv = FALSE)

# then convert  into SpatialPoints objects
locs <- SpatialPoints(coords = locs_nztm, proj4string = TA@proj4string)

#-------------Match to Territorial Authority-------
locs2 <- over(locs, TA)
distinct_voting_places$TA2014_NAM <- locs2$TA2014_NAM


#-------------Match to Region------------------
REG <- readOGR("downloads/shapefiles/2014 Digital Boundaries Generlised Clipped",
              "REGC2014_GV_Clipped")

locs2 <- over(locs, REG)
distinct_voting_places$REGC2014_N <- locs2$REGC2014_N

#-------------Match to Area Unit------------------
AU <- readOGR("downloads/shapefiles/2014 Digital Boundaries Generlised Clipped",
               "AU2014_GV_Clipped")
locs2 <- over(locs, AU)
distinct_voting_places$AU2014 <- locs2$AU2014

#-------------Match to Mesh Block------------------
MB <- readOGR("downloads/shapefiles/2014 Digital Boundaries Generlised Clipped",
              "MB2014_GV_Clipped")

locs2 <- over(locs, MB)
distinct_voting_places$MB2014 <- locs2$MB2014
