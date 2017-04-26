
#============Regions=============
data(Region)
p4s <- proj4string(Region)
tmp <- Region # from mbiemaps

tmp@data <- REGC2013 %>%
    rename(Name = REGC2013_N) %>%
    filter(!grepl("area outside", Name, ignore.case = TRUE)) %>%
    select(Name, ResidentPop2013) %>%
    rename(RsPop2013= ResidentPop2013 )%>%
    right_join(tmp@data, by = c("Name" = "NAME")) %>%
    select(-SHAPE_Area, - SHAPE_Leng)

# simplified version, with no Area Outside Region, and less space
tmp <- rmapshaper::ms_simplify(tmp)
tmp@data$rmapshaperid <- NULL

unlink("tmp/*")
writeOGR(tmp, "tmp", layer = "regions", driver="ESRI Shapefile")

# Open ScapeToad and do the distortion in there with point-and-click

reg_cart <- readOGR("tmp", "regions-cart")

proj4string(reg_cart) <- p4s
reg_cart <- spTransform(reg_cart, CRS("+init=epsg:4326"))

reg_cart@data <- reg_cart@data %>%
    mutate(RsPop2013 = as.numeric(as.character(RsPop2013)))

# plausibility test:
par(fg = "white")
plot(reg_cart, col = 1:16)

save(reg_cart, file = "pkg2/data/reg_cart.rda")


#============Territorial Authorities=============
data(TA)
tmp <- TA

tmp@data <- TA2013 %>%
    rename(Name = TA2013_NAM) %>%
    filter(!grepl("area outside", Name, ignore.case = TRUE)) %>%
    select(Name, ResidentPop2013) %>%
    rename(RsPop2013= ResidentPop2013 )%>%
    right_join(tmp@data, by = c("Name" = "NAME")) %>%
    select(-SHAPE_Area, - SHAPE_Leng)

# simplified version, with no Area Outside Region, and less space
tmp <- rmapshaper::ms_simplify(tmp)
tmp@data$rmapshaperid <- NULL

writeOGR(tmp, "tmp", layer = "ta", driver="ESRI Shapefile")

# Open ScapeToad and do the distortion in there with point-and-click

ta_cart <- readOGR("tmp", "ta-cart")

proj4string(ta_cart) <- p4s
ta_cart <- spTransform(ta_cart, CRS("+init=epsg:4326"))

ta_cart@data <- ta_cart@data %>%
    mutate(RsPop2013 = as.numeric(as.character(RsPop2013)))

# plausibility test:
par(fg = "white")
plot(ta_cart, col = sample(viridis::inferno(70), 70))

save(ta_cart, file = "pkg2/data/ta_cart.rda")


#============Area Units=============
AU <- readOGR("downloads/shapefiles/2014 Digital Boundaries Generlised Clipped",
              "AU2014_GV_Clipped")

# see https://gis.stackexchange.com/questions/20389/converting-nzmg-or-nztm-to-latitude-longitude-for-use-with-r-map-library
p4s <- "+proj=tmerc +lat_0=0.0 +lon_0=173.0 +k=0.9996 +x_0=1600000.0 +y_0=10000000.0 +datum=WGS84 +units=m"

tmp <- AU
names(AU@data)
tmp@data <- AreaUnits2013 %>%
    rename(Name = AU_NAM) %>%
    filter(!grepl("area outside", Name, ignore.case = TRUE)) %>%
    select(Name, ResidentPop2013) %>%
    rename(RsPop2013= ResidentPop2013 )%>%
    right_join(tmp@data, by = c("Name" = "AU2014_NAM")) %>%
    select(-SHAPE_Area, - SHAPE_Leng)

# simplified version, with no Area Outside Region, and less space
tmp <- rmapshaper::ms_simplify(tmp)
tmp@data$rmapshaperid <- NULL

writeOGR(tmp, "tmp", layer = "au", driver="ESRI Shapefile")

# Open ScapeToad and do the distortion in there with point-and-click

au_cart <- readOGR("tmp", "au-cart")

proj4string(au_cart) <- p4s
au_cart <- spTransform(au_cart, CRS("+init=epsg:4326"))

au_cart@data <- au_cart@data %>%
    mutate(RsPop2013 = as.numeric(as.character(RsPop2013)))

au_cart <- au_cart[!grepl("Chatham Island", au_cart@data$Name), ]


# plausibility test:
par(fg = "white")
plot(au_cart, col = sample(viridis::inferno(70), 70))

save(au_cart, file = "pkg2/data/au_cart.rda")

#============mesbhocks=============
MB <- readOGR("downloads/shapefiles/2014 Digital Boundaries Generlised Clipped",
              "MB2014_GV_Clipped")

tmp <- MB

tmp@data <- Meshblocks2013 %>%
    select(MB, ResidentPop2013) %>%
    rename(RsPop2013= ResidentPop2013 ) %>%
    right_join(tmp@data, by = c("MB" = "MB2014")) 

# simplified version, with no Area Outside Region, and less space
tmp <- rmapshaper::ms_simplify(tmp)
tmp@data$rmapshaperid <- NULL

writeOGR(tmp, "tmp", layer = "mb", driver="ESRI Shapefile")

# Open ScapeToad and do the distortion in there with point-and-click

mb_cart <- readOGR("tmp", "mb-cart")

proj4string(mb_cart) <- p4s
mb_cart <- spTransform(mb_cart, CRS("+init=epsg:4326"))

mb_cart@data <- mb_cart@data %>%
    mutate(RsPop2013 = as.numeric(as.character(RsPop2013)))

mb_cart <- mb_cart[!grepl("Chatham Island", mb_cart@data$AU2014_NAM), ]

# plausibility test:
par(fg = "white")
plot(mb_cart, col = sample(viridis::inferno(70), 70))

save(mb_cart, file = "pkg2/data/mb_cart.rda")
