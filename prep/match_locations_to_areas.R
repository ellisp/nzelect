library(rgdal)


#------------------convert locations to sp format-----------
locs <- SpatialPoints(coords = Locations2014[, c("NZTM2000Easting", "NZTM2000Northing")],
                      proj4string = TA@proj4string)

#-------------Match to Territorial Authority------------------
TA <- readOGR("downloads/shapefiles/2014 Digital Boundaries Generlised Full",
              "TA2014_GV_Full")

locs2 <- over(locs, TA)
Locations2014$TA2014_NAM <- locs2$TA2014_NAM


#-------------Match to Region------------------
REG <- readOGR("downloads/shapefiles/2014 Digital Boundaries Generlised Full",
              "REGC2014_GV_Full")

locs2 <- over(locs, REG)
Locations2014$REGC2014_N <- locs2$REGC2014_N

#-------------Match to Area Unit------------------
AU <- readOGR("downloads/shapefiles/2014 Digital Boundaries Generlised Full",
               "AU2014_GV_Full")

locs2 <- over(locs, AU)
Locations2014$AU2014 <- locs2$AU2014
