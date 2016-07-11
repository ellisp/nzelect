ps <- "+proj=tmerc +lat_0=0.0 +lon_0=173.0 +k=0.9996 +x_0=1600000.0 +y_0=10000000.0 +datum=WGS84 +units=m"

# create a function for efficiently matching locations to our various area unit, TA, region, meshblock datasets:
add_coords <- function(data, sp_obj, by){
    

#    sp_obj <- AU; data <- AreaUnits2013; by = "AU2014"
    
    centroids <- as.data.frame(coordinates(sp_obj))
    names(centroids) <- c("NZTM2000Easting", "NZTM2000Northing")
    # need to convert these to lat and long
    p <- proj4::project(centroids, proj = ps, inverse=T)
    spatial_info <- cbind(sp_obj@data, centroids, 
                          WGS84Longitude = p[[1]], WGS84Latitude = p[[2]])
    
    # convert factors to characters
    data[ , names(data) == by] <- as.character(data[ , names(data) == by])
    spatial_info[ , names(spatial_info) == by] <- 
        as.character(spatial_info[ , names(spatial_info) == by])
    
    tmp <- data %>%
        left_join(spatial_info, by = by)
    
    return(tmp)
}


Meshblocks2013 <- add_coords(Meshblocks2013_tmp, MB, c("MB" = "MB2014")) # shouldn't this use 2013 meshblocks...
AreaUnits2013 <- add_coords(AreaUnits2013_tmp, AU, "AU2014") %>%
    mutate(AU_NAM = ifelse(is.na(AU2014_NAM), substring(Area_Code_and_Description, 8), as.character(AU2014_NAM)))
TA2013 <- add_coords(TA2013_tmp, TA, c("TA2013_NAM" = "TA2014_NAM"))
REGC2013 <- add_coords(REGC2013_tmp, REG, c("REGC" = "REGC2014"))



# ggplot(REGC2013, aes(x = WGS84Longitude, y = WGS84Latitude, label = REGC2014_N)) +
#     geom_text() +
#     coord_map(xlim = c(165, 180))

# remove some redundant columns
AreaUnits2013$Area_Code_and_Description <- NULL
AreaUnits2013$SHAPE_STAr <- NULL
AreaUnits2013$SHAPE_STLe <- NULL
AreaUnits2013$AU2014_NAM <- NULL

TA2013$TA2014 <- NULL

REGC2013$REGC2014_N <- NULL
REGC2013$SHAPE_STLe <- NULL

# I don't understand the units of length and area; and anyone who really needs
# them can get them from the shapefiles easily enough so I'm going to knock
# them out:
Meshblocks2013$SHAPE_Leng <- NULL
Meshblocks2013$SHAPE_Area <- NULL
AreaUnits2013$Shape_Leng <- NULL
AreaUnits2013$Shape_Area <- NULL
TA2013$SHAPE_Leng <- NULL
TA2013$SHAPE_Area <- NULL
REGC2013$SHAPE_Leng <- NULL
REGC2013$SHAPE_Area <- NULL



save(Meshblocks2013, file = "pkg2/data/Meshblocks2013.rda", compress = "xz")
save(AreaUnits2013, file = "pkg2/data/AreaUnits2013.rda", compress = "xz")
save(TA2013, file = "pkg2/data/TA2013.rda")
save(REGC2013, file = "pkg2/data/REGC2013.rda")

